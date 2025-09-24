class platform::filesystem::params (
  $vg_name = 'cgts-vg',
) {}


define platform::filesystem (
  $lv_name,
  $lv_size,
  $mountpoint,
  $fs_type,
  $fs_options,
  $fs_use_all = false,
  $ensure = present,
  $group = 'root',
  $mode = '0750',
) {
  include ::platform::filesystem::params
  $vg_name = $::platform::filesystem::params::vg_name

  $device = "/dev/${vg_name}/${lv_name}"

  if !$fs_use_all {
    $size = "${lv_size}G"
    $fs_size_is_minsize = true
  }
  else {
    # use all available space
    $size = undef
    $fs_size_is_minsize = false
  }

  if ($ensure == 'absent') {
    exec { "umount mountpoint ${mountpoint}":
      command => "umount ${mountpoint}; true",
      onlyif  => "test -e ${mountpoint}",
    }
    -> mount { $name:
      ensure  => $ensure,
      atboot  => 'yes',
      name    => $mountpoint,
      device  => $device,
      options => 'defaults',
      fstype  => $fs_type,
    }
    -> file { $mountpoint:
      ensure => $ensure,
      force  => true,
    }
    -> exec { "wipe start of device ${device}":
      command => "dd if=/dev/zero of=${device} bs=512 count=34",
      onlyif  => "blkid ${device}",
    }
    -> exec { "wipe end of device ${device}":
      command => "dd if=/dev/zero of=${device} bs=512 seek=$(($(blockdev --getsz ${device}) - 34)) count=34",
      onlyif  => "blkid ${device}",
    }
    -> exec { "lvremove lv ${lv_name}":
      command => "lvremove -f cgts-vg ${lv_name}; true",
      onlyif  => "test -e /dev/cgts-vg/${lv_name}"
    }
  }

  if ($ensure == 'present') {
    # create logical volume
    logical_volume { $lv_name:
        ensure          => $ensure,
        volume_group    => $vg_name,
        size            => $size,
        size_is_minsize => $fs_size_is_minsize,
    }

    # Wipe 10MB at the beginning and at the end
    # of each LV in cgts-vg to prevent problems caused
    # by stale data on the disk
    -> exec { "wipe start of device ${lv_name}":
      command => "dd if=/dev/zero of=${lv_name} bs=1M count=10",
      onlyif  => "test ! -e /etc/platform/.${lv_name}"
    }
    -> exec { "wipe end of device ${lv_name}":
      command => "dd if=/dev/zero of=${lv_name} bs=1M seek=$(($(blockdev --getsz ${lv_name})/2048 - 10)) count=10",
      onlyif  => "test ! -e /etc/platform/.${lv_name}"
    }
    -> exec { "mark lv as wiped ${lv_name}:":
      command => "touch /etc/platform/.${lv_name}",
      onlyif  => "test ! -e /etc/platform/.${lv_name}"
    }
    # create filesystem
    -> filesystem { $device:
      ensure  => $ensure,
      fs_type => $fs_type,
      options => $fs_options,
    }

    -> file { $mountpoint:
      ensure => 'directory',
      owner  => 'root',
      group  => $group,
      mode   => $mode,
    }

    -> mount { $name:
      ensure  => 'mounted',
      atboot  => 'yes',
      name    => $mountpoint,
      device  => $device,
      options => 'defaults',
      fstype  => $fs_type,
    }

    # The above mount resource doesn't actually remount devices that were already present in /etc/fstab, but were
    # unmounted during manifest application. To get around this, we attempt to mount them again, if they are not
    # already mounted.
    -> exec { "mount ${device}":
      unless  => "mount | awk '{print \$3}' | grep -Fxq ${mountpoint}",
      command => "mount ${mountpoint}",
      path    => '/usr/bin'
    }
    -> exec {"Change ${mountpoint} dir permissions":
      command => "chmod ${mode} ${mountpoint}",
    }
    -> exec {"Change ${mountpoint} dir group":
      command => "chgrp ${group} ${mountpoint}",
    }
  }
}


define platform::filesystem::resize(
  $lv_name,
  $lv_size,
  $devmapper,
) {
  include ::platform::filesystem::params
  $vg_name = $::platform::filesystem::params::vg_name

  $device = "/dev/${vg_name}/${lv_name}"

  # TODO (rchurch): Fix this... Allowing return code 5 so that lvextends using the same size doesn't blow up
  exec { "lvextend ${device}":
    command => "lvextend -L${lv_size}G ${device}",
    returns => [0, 5]
  }
  # After a partition extend, wipe 10MB at the end of the partition
  # to make sure that there is no leftover
  # type metadata from a previous install
  -> exec { "wipe end of device ${device}":
    command => "dd if=/dev/zero of=${device} bs=1M seek=$(($(blockdev --getsz ${device})/2048 - 10)) count=10",
  }
  -> exec { "resize2fs ${devmapper}":
    command => "resize2fs ${devmapper}",
    onlyif  => "blkid -s TYPE -o value ${devmapper} | grep -v xfs",
  }
  -> exec { "xfs_growfs ${devmapper}":
    command => "xfs_growfs ${devmapper}",
    onlyif  => "blkid -s TYPE -o value ${devmapper} | grep xfs",
  }
}


class platform::filesystem::backup::params (
  $lv_name = 'backup-lv',
  $lv_size = '1',
  $mountpoint = '/opt/backups',
  $devmapper = '/dev/mapper/cgts--vg-backup--lv',
  $fs_type = 'ext4',
  $fs_options = ' '
) {}

class platform::filesystem::backup
  inherits ::platform::filesystem::backup::params {

  platform::filesystem { $lv_name:
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    mountpoint => $mountpoint,
    fs_type    => $fs_type,
    fs_options => $fs_options
  }
}

class platform::filesystem::conversion::params (
  $conversion_enabled = false,
  $ensure = absent,
  $lv_size = '1',
  $lv_name = 'conversion-lv',
  $mountpoint = '/opt/conversion',
  $devmapper = '/dev/mapper/cgts--vg-conversion--lv',
  $fs_type = 'ext4',
  $fs_options = ' ',
  $mode = '0750'
) { }

class platform::filesystem::scratch::params (
  $lv_size = '2',
  $lv_name = 'scratch-lv',
  $mountpoint = '/scratch',
  $devmapper = '/dev/mapper/cgts--vg-scratch--lv',
  $fs_type = 'ext4',
  $fs_options = ' ',
  $group = 'sys_protected',
  $mode = '0770'
) { }

class platform::filesystem::scratch
  inherits ::platform::filesystem::scratch::params {

  platform::filesystem { $lv_name:
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    mountpoint => $mountpoint,
    fs_type    => $fs_type,
    fs_options => $fs_options,
    group      => $group,
    mode       => $mode
  }
}

class platform::filesystem::conversion
  inherits ::platform::filesystem::conversion::params {

  if $conversion_enabled {
    $ensure = present
    $mode = '0777'
  }
  platform::filesystem { $lv_name:
    ensure     => $ensure,
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    mountpoint => $mountpoint,
    fs_type    => $fs_type,
    fs_options => $fs_options,
    mode       => $mode
  }
}

class platform::filesystem::kubelet::params (
  $lv_size = '2',
  $lv_name = 'kubelet-lv',
  $mountpoint = '/var/lib/kubelet',
  $devmapper = '/dev/mapper/cgts--vg-kubelet--lv',
  $fs_type = 'ext4',
  $fs_options = ' '
) { }

class platform::filesystem::kubelet
  inherits ::platform::filesystem::kubelet::params {

  platform::filesystem { $lv_name:
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    mountpoint => $mountpoint,
    fs_type    => $fs_type,
    fs_options => $fs_options
  }
}

class platform::filesystem::docker::params (
  $lv_size = '1',
  $lv_name = 'docker-lv',
  $mountpoint = '/var/lib/docker',
  $devmapper = '/dev/mapper/cgts--vg-docker--lv',
  $fs_type = 'xfs',
  $fs_options = '-n ftype=1',
  $fs_use_all = false
) { }

class platform::filesystem::docker
  inherits ::platform::filesystem::docker::params {

  platform::filesystem { $lv_name:
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    mountpoint => $mountpoint,
    fs_type    => $fs_type,
    fs_options => $fs_options,
    fs_use_all => $fs_use_all,
    mode       => '0711',
  }
}

class platform::filesystem::storage {
  include ::platform::filesystem::kubelet

  class {'platform::filesystem::docker::params' :
    lv_size => 30
  }
  -> class {'platform::filesystem::docker' :
  }

  Class['::platform::lvm::vg::cgts_vg'] -> Class[$name]
}


class platform::filesystem::compute {
  if $::personality == 'worker' {
    # The default docker size for controller is 20G
    # other than 30G. To prevent the docker size to
    # be overrided to 30G for AIO, this is scoped to
    # worker node.
    include ::platform::filesystem::kubelet
    class {'platform::filesystem::docker::params' :
      lv_size => 30
    }
    -> class {'platform::filesystem::docker' :
    }
  }

  Class['::platform::lvm::vg::cgts_vg'] -> Class[$name]
}

class platform::filesystem::controller {
  include ::platform::filesystem::backup
  include ::platform::filesystem::scratch
  include ::platform::filesystem::conversion
  include ::platform::filesystem::docker
  include ::platform::filesystem::kubelet
}


class platform::filesystem::backup::runtime {

  include ::platform::filesystem::backup::params
  $lv_name = $::platform::filesystem::backup::params::lv_name
  $lv_size = $::platform::filesystem::backup::params::lv_size
  $devmapper = $::platform::filesystem::backup::params::devmapper

  platform::filesystem::resize { $lv_name:
    lv_name   => $lv_name,
    lv_size   => $lv_size,
    devmapper => $devmapper,
  }
}


class platform::filesystem::scratch::runtime {

  include ::platform::filesystem::scratch::params
  $lv_name = $::platform::filesystem::scratch::params::lv_name
  $lv_size = $::platform::filesystem::scratch::params::lv_size
  $devmapper = $::platform::filesystem::scratch::params::devmapper

  platform::filesystem::resize { $lv_name:
    lv_name   => $lv_name,
    lv_size   => $lv_size,
    devmapper => $devmapper,
  }
}

class platform::filesystem::conversion::runtime {
  include ::platform::filesystem::conversion
  include ::platform::filesystem::conversion::params

  $conversion_enabled = $::platform::filesystem::conversion::params::conversion_enabled
  $lv_name = $::platform::filesystem::conversion::params::lv_name
  $lv_size = $::platform::filesystem::conversion::params::lv_size
  $devmapper = $::platform::filesystem::conversion::params::devmapper

  if $conversion_enabled {
    Class['::platform::filesystem::conversion']
    -> platform::filesystem::resize { $lv_name:
      lv_name   => $lv_name,
      lv_size   => $lv_size,
      devmapper => $devmapper,
    }
  }
}

class platform::filesystem::kubelet::runtime {

  include ::platform::filesystem::kubelet::params
  $lv_name = $::platform::filesystem::kubelet::params::lv_name
  $lv_size = $::platform::filesystem::kubelet::params::lv_size
  $devmapper = $::platform::filesystem::kubelet::params::devmapper

  platform::filesystem::resize { $lv_name:
    lv_name   => $lv_name,
    lv_size   => $lv_size,
    devmapper => $devmapper,
  }
}


class platform::filesystem::docker::runtime {

  include ::platform::filesystem::docker::params
  $lv_name = $::platform::filesystem::docker::params::lv_name
  $lv_size = $::platform::filesystem::docker::params::lv_size
  $devmapper = $::platform::filesystem::docker::params::devmapper

  platform::filesystem::resize { $lv_name:
    lv_name   => $lv_name,
    lv_size   => $lv_size,
    devmapper => $devmapper,
  }
}


class platform::filesystem::docker::params::bootstrap (
  $lv_size = '20',
  $lv_name = 'docker-lv',
  $mountpoint = '/var/lib/docker',
  $devmapper = '/dev/mapper/cgts--vg-docker--lv',
  $fs_type = 'xfs',
  $fs_options = '-n ftype=1',
  $fs_use_all = false
) { }


class platform::filesystem::docker::bootstrap
  inherits ::platform::filesystem::docker::params::bootstrap {

  platform::filesystem { $lv_name:
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    mountpoint => $mountpoint,
    fs_type    => $fs_type,
    fs_options => $fs_options,
    fs_use_all => $fs_use_all,
    mode       => '0711',
  }
}
