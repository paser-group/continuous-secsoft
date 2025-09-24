class platform::drbd::params (
  $link_speed,
  $link_util,
  $num_parallel,
  $rtt_ms,
  $automount     = false,
  $ha_primary    = false,
  $initial_setup = false,
  $fs_type       = 'ext4',
  $cpumask = false,
) {
  include ::platform::params
  $host1 = $::platform::params::controller_0_hostname
  $host2 = $::platform::params::controller_1_hostname

  include ::platform::network::mgmt::params
  $ip1 = $::platform::network::mgmt::params::controller0_address
  $ip2 = $::platform::network::mgmt::params::controller1_address

  $manage = str2bool($::is_initial_config)
}


define platform::drbd::filesystem (
  $lv_name,
  $vg_name,
  $lv_size,
  $port,
  $device,
  $mountpoint,
  $resync_after = undef,
  $sm_service = $title,
  $ha_primary_override = undef,
  $initial_setup_override = undef,
  $automount_override = undef,
  $manage_override = undef,
  $ip2_override = undef,
) {

  if $manage_override == undef {
    $drbd_manage = $::platform::drbd::params::manage
  } else {
    $drbd_manage = $manage_override
  }
  if $ha_primary_override == undef {
    $drbd_primary = $::platform::drbd::params::ha_primary
  } else {
    $drbd_primary = $ha_primary_override
  }
  if $initial_setup_override == undef {
    $drbd_initial = $::platform::drbd::params::initial_setup
  } else {
    $drbd_initial = $initial_setup_override
  }
  if $automount_override == undef {
    $drbd_automount = $::platform::drbd::params::automount
  } else {
    $drbd_automount = $automount_override
  }
  if $ip2_override == undef {
    $ip2 = $::platform::drbd::params::ip2
  } else {
    $ip2 = $ip2_override
  }


  logical_volume { $lv_name:
    ensure          => present,
    volume_group    => $vg_name,
    size            => "${lv_size}G",
    size_is_minsize => true,
  }


  -> drbd::resource { $title:
    disk          => "/dev/${vg_name}/${lv_name}",
    port          => $port,
    device        => $device,
    mountpoint    => $mountpoint,
    handlers      => {
      before-resync-target =>
        "/usr/local/sbin/sm-notify -s ${sm_service} -e sync-start",
      after-resync-target  =>
        "/usr/local/sbin/sm-notify -s ${sm_service} -e sync-end",
    },
    host1         => $::platform::drbd::params::host1,
    host2         => $::platform::drbd::params::host2,
    ip1           => $::platform::drbd::params::ip1,
    ip2           => $ip2,
    manage        => $drbd_manage,
    ha_primary    => $drbd_primary,
    initial_setup => $drbd_initial,
    automount     => $drbd_automount,
    fs_type       => $::platform::drbd::params::fs_type,
    link_util     => $::platform::drbd::params::link_util,
    link_speed    => $::platform::drbd::params::link_speed,
    num_parallel  => $::platform::drbd::params::num_parallel,
    rtt_ms        => $::platform::drbd::params::rtt_ms,
    cpumask       => $::platform::drbd::params::cpumask,
    resync_after  => $resync_after,
  }
}

# The device names (/dev/drbdX) for all drbd devices added in this manifest
# should be kept in sync with the ones present in the restore ansible playbook
# present in the ansible-playbooks repo at:
# playbookconfig/src/playbooks/roles/restore-platform/restore-more-data/tasks/main.yml
# (ansible task name is "Resize DRBD filesystems").
# This is done because the device names are only defined here and never reach
# sysinv, so there is no way to get this info from another place.
# If adding another drbd-synced resource, check backup&restore works after resizing
# the resource.
#
# NOTE: Only devices present in the "system controllerfs-list" command output
#       need to be kept in sync. Filesystem that we don't allow resizing for
#       (for example rabbitmq) or those that don't use the controllerfs
#       command (for example cephmon) don't need to be kept in sync.
class platform::drbd::pgsql::params (
  $device = '/dev/drbd0',
  $lv_name = 'pgsql-lv',
  $lv_size = '2',
  $mountpoint = '/var/lib/postgresql',
  $port = '7789',
  $resource_name = 'drbd-pgsql',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::pgsql (
) inherits ::platform::drbd::pgsql::params {

  platform::drbd::filesystem { $resource_name:
    vg_name    => $vg_name,
    lv_name    => $lv_name,
    lv_size    => $lv_size,
    port       => $port,
    device     => $device,
    mountpoint => $mountpoint,
    sm_service => 'drbd-pg',
  }
}


class platform::drbd::rabbit::params (
  $device = '/dev/drbd1',
  $lv_name = 'rabbit-lv',
  $lv_size = '2',
  $mountpoint = '/var/lib/rabbitmq',
  $port = '7799',
  $resource_name = 'drbd-rabbit',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::rabbit ()
  inherits ::platform::drbd::rabbit::params {

  platform::drbd::filesystem { $resource_name:
    vg_name      => $vg_name,
    lv_name      => $lv_name,
    lv_size      => $lv_size,
    port         => $port,
    device       => $device,
    mountpoint   => $mountpoint,
    resync_after => 'drbd-pgsql',
  }
}


class platform::drbd::platform::params (
  $device = '/dev/drbd2',
  $lv_name = 'platform-lv',
  $lv_size = '1',
  $mountpoint = '/opt/platform',
  $port = '7790',
  $vg_name = 'cgts-vg',
  $resource_name = 'drbd-platform',
) {}

class platform::drbd::platform ()
  inherits ::platform::drbd::platform::params {

  platform::drbd::filesystem { $resource_name:
    vg_name      => $vg_name,
    lv_name      => $lv_name,
    lv_size      => $lv_size,
    port         => $port,
    device       => $device,
    mountpoint   => $mountpoint,
    resync_after => 'drbd-rabbit',
  }
}


class platform::drbd::extension::params (
  $device = '/dev/drbd5',
  $lv_name = 'extension-lv',
  $lv_size = '1',
  $mountpoint = '/opt/extension',
  $port = '7793',
  $resource_name = 'drbd-extension',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::extension (
) inherits ::platform::drbd::extension::params {

  include ::platform::params
  include ::platform::drbd::platform::params

  if str2bool($::is_primary_disk_rotational) {
    $resync_after = $::platform::drbd::platform::params::resource_name
  } else {
    $resync_after = undef
  }

  platform::drbd::filesystem { $resource_name:
    vg_name      => $vg_name,
    lv_name      => $lv_name,
    lv_size      => $lv_size,
    port         => $port,
    device       => $device,
    mountpoint   => $mountpoint,
    resync_after => $resync_after,
  }
}

class platform::drbd::dc_vault::params (
  $service_enabled = false,
  $device = '/dev/drbd6',
  $lv_name = 'dc-vault-lv',
  $lv_size = '15',
  $mountpoint = '/opt/dc-vault',
  $port = '7794',
  $resource_name = 'drbd-dc-vault',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::dc_vault (
) inherits ::platform::drbd::dc_vault::params {

  if str2bool($::is_standalone_controller) {
    $drbd_primary = true
    $drbd_initial = true
    $drbd_automount = true
    $drbd_manage = true
  } else {
    $drbd_primary = undef
    $drbd_initial = undef
    $drbd_automount = undef
    $drbd_manage = undef
  }

  if $service_enabled {
    platform::drbd::filesystem { $resource_name:
      vg_name                => $vg_name,
      lv_name                => $lv_name,
      lv_size                => $lv_size,
      port                   => $port,
      device                 => $device,
      mountpoint             => $mountpoint,
      resync_after           => 'drbd-extension',
      manage_override        => $drbd_manage,
      ha_primary_override    => $drbd_primary,
      initial_setup_override => $drbd_initial,
      automount_override     => $drbd_automount,
    }
  }
}

class platform::drbd::etcd::params (
  #$service_enable = false,
  $device = '/dev/drbd7',
  $lv_name = 'etcd-lv',
  $lv_size = '1',
  $mountpoint = '/opt/etcd',
  $port = '7797',
  $resource_name = 'drbd-etcd',
  $vg_name = 'cgts-vg',
) {}


class platform::drbd::etcd (
) inherits ::platform::drbd::etcd::params {

  $drbd_primary = undef
  $drbd_initial = undef
  $drbd_automount = undef
  $drbd_manage = undef

  platform::drbd::filesystem { $resource_name:
    vg_name                => $vg_name,
    lv_name                => $lv_name,
    lv_size                => $lv_size,
    port                   => $port,
    device                 => $device,
    mountpoint             => $mountpoint,
    resync_after           => undef,
    manage_override        => $drbd_manage,
    ha_primary_override    => $drbd_primary,
    initial_setup_override => $drbd_initial,
    automount_override     => $drbd_automount,
  }
}

class platform::drbd::etcd::bootstrap (
) inherits ::platform::drbd::etcd::params {

  $drbd_primary = true
  $drbd_initial = true
  $drbd_automount = true
  $drbd_manage = true

  platform::drbd::filesystem { $resource_name:
    vg_name                => $vg_name,
    lv_name                => $lv_name,
    lv_size                => $lv_size,
    port                   => $port,
    device                 => $device,
    mountpoint             => $mountpoint,
    resync_after           => undef,
    manage_override        => $drbd_manage,
    ha_primary_override    => $drbd_primary,
    initial_setup_override => $drbd_initial,
    automount_override     => $drbd_automount,
  }
}

class platform::drbd::dockerdistribution::params (
  $device = '/dev/drbd8',
  $lv_name = 'dockerdistribution-lv',
  $lv_size = '8',
  $mountpoint = '/var/lib/docker-distribution',
  $port = '7798',
  $resource_name = 'drbd-dockerdistribution',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::dockerdistribution ()
  inherits ::platform::drbd::dockerdistribution::params {

  $drbd_primary = undef
  $drbd_initial = undef
  $drbd_automount = undef
  $drbd_manage = undef

  platform::drbd::filesystem { $resource_name:
    vg_name                => $vg_name,
    lv_name                => $lv_name,
    lv_size                => $lv_size,
    port                   => $port,
    device                 => $device,
    mountpoint             => $mountpoint,
    resync_after           => undef,
    manage_override        => $drbd_manage,
    ha_primary_override    => $drbd_primary,
    initial_setup_override => $drbd_initial,
    automount_override     => $drbd_automount,
  }
}

class platform::drbd::dockerdistribution::bootstrap ()
  inherits ::platform::drbd::dockerdistribution::params {

  $drbd_primary = true
  $drbd_initial = true
  $drbd_automount = true
  $drbd_manage = true

  platform::drbd::filesystem { $resource_name:
    vg_name                => $vg_name,
    lv_name                => $lv_name,
    lv_size                => $lv_size,
    port                   => $port,
    device                 => $device,
    mountpoint             => $mountpoint,
    resync_after           => undef,
    manage_override        => $drbd_manage,
    ha_primary_override    => $drbd_primary,
    initial_setup_override => $drbd_initial,
    automount_override     => $drbd_automount,
  }
}

class platform::drbd::cephmon::params (
  $device = '/dev/drbd9',
  $lv_name = 'ceph-mon-lv',
  $mountpoint = '/var/lib/ceph/mon',
  $port = '7788',
  $resource_name = 'drbd-cephmon',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::cephmon ()
  inherits ::platform::drbd::cephmon::params {

  include ::platform::ceph::params

  $system_mode = $::platform::params::system_mode
  $system_type = $::platform::params::system_type

  if ((str2bool($::is_controller_active) or str2bool($::is_standalone_controller))
    and ! str2bool($::is_node_ceph_configured)) {
    # Active controller, first time configuration.
    $drbd_primary = true
    $drbd_initial = true
    $drbd_automount = true

  } elsif str2bool($::is_standalone_controller) {
    # Active standalone controller, successive reboots.
    $drbd_primary = true
    $drbd_initial = undef
    $drbd_automount = true
  } else {
    # Node unlock, reboot or standby configuration
    # Do not mount ceph
    $drbd_primary = undef
    $drbd_initial = undef
    $drbd_automount = undef
  }

  if ($::platform::ceph::params::service_enabled and
    $system_type == 'All-in-one' and 'duplex' in $system_mode) {
    platform::drbd::filesystem { $resource_name:
      vg_name                => $vg_name,
      lv_name                => $lv_name,
      lv_size                => $::platform::ceph::params::mon_lv_size,
      port                   => $port,
      device                 => $device,
      mountpoint             => $mountpoint,
      resync_after           => undef,
      manage_override        => true,
      ha_primary_override    => $drbd_primary,
      initial_setup_override => $drbd_initial,
      automount_override     => $drbd_automount,
    }
  }
}

class platform::drbd::rookmon::params (
  $device = '/dev/drbd9',
  $lv_name = 'ceph-mon-lv',
  $mountpoint = '/var/lib/ceph/mon-a',
  $port = '7788',
  $resource_name = 'drbd-cephmon',
  $vg_name = 'cgts-vg',
) {}

class platform::drbd::rookmon ()
  inherits ::platform::drbd::rookmon::params {

  include ::platform::rook::params

  $system_mode = $::platform::params::system_mode
  $system_type = $::platform::params::system_type

  if ((str2bool($::is_controller_active) or str2bool($::is_standalone_controller))
    and ! str2bool($::is_node_rook_ceph_configured)) {
    # Active controller, first time configuration.
    $drbd_primary = true
    $drbd_initial = true
    $drbd_automount = true

  } elsif str2bool($::is_standalone_controller) {
    # Active standalone controller, successive reboots.
    $drbd_primary = true
    $drbd_initial = undef
    $drbd_automount = true
  } else {
    # Node unlock, reboot or standby configuration
    # Do not mount ceph
    $drbd_primary = undef
    $drbd_initial = undef
    $drbd_automount = undef
  }

  if ($platform::rook::params::service_enabled and
    $system_type == 'All-in-one' and 'duplex' in $system_mode) {
    platform::drbd::filesystem { $resource_name:
      vg_name                => $vg_name,
      lv_name                => $lv_name,
      lv_size                => $platform::rook::params::mon_lv_size,
      port                   => $port,
      device                 => $device,
      mountpoint             => $mountpoint,
      resync_after           => undef,
      manage_override        => true,
      ha_primary_override    => $drbd_primary,
      initial_setup_override => $drbd_initial,
      automount_override     => $drbd_automount,
    }
  }
}

class platform::drbd(
  $service_enable = false,
  $service_ensure = 'stopped',
) {
  if str2bool($::is_standalone_controller)
  {
    # Enable DRBD on standalone
    class { '::drbd':
      service_enable => true,
      service_ensure => 'running',
    }
  } else {
    class { '::drbd':
      service_enable => $service_enable,
      service_ensure => $service_ensure,
    }
    include ::drbd
  }

  include ::platform::drbd::params
  include ::platform::drbd::pgsql
  include ::platform::drbd::rabbit
  include ::platform::drbd::platform
  include ::platform::drbd::extension
  include ::platform::drbd::dc_vault
  include ::platform::drbd::etcd
  include ::platform::drbd::dockerdistribution
  include ::platform::drbd::cephmon
  include ::platform::drbd::rookmon
  include ::platform::drbd::trigger_resize_check

  # network changes need to be applied prior to DRBD resources
  Anchor['platform::networking']
  -> Drbd::Resource <| |>
  -> Anchor['platform::services']
}


class platform::drbd::bootstrap {

  class { '::drbd':
    service_enable => true,
    service_ensure => 'running'
  }

  # override the defaults to initialize and activate the file systems
  class { '::platform::drbd::params':
    ha_primary    => true,
    initial_setup => true,
    automount     => true,
  }

  include ::platform::drbd::pgsql
  include ::platform::drbd::rabbit
  include ::platform::drbd::platform
  include ::platform::drbd::extension
  include ::platform::drbd::trigger_resize_check
}


class platform::drbd::runtime {

  class { '::platform::drbd':
    service_enable => true,
    service_ensure => 'running',
  }
}

class platform::drbd::runtime_service_enable {

  class { '::drbd':
    service_enable => true,
    service_ensure => 'running'
  }
}

class platform::drbd::trigger_resize_check {
  file {'/etc/platform/.cfs_drbdadm_reconfigured':
    ensure => absent
  }
  file {'/var/run/.config_controller_fini':
    ensure => absent
  }
}

class platform::drbd::pgsql::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::pgsql
  include ::platform::drbd::trigger_resize_check
}


class platform::drbd::platform::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::platform
  include ::platform::drbd::trigger_resize_check
}


class platform::drbd::extension::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::extension
  include ::platform::drbd::trigger_resize_check
}


class platform::drbd::dc_vault::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::dc_vault
  include ::platform::drbd::trigger_resize_check
}

class platform::drbd::etcd::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::etcd
  include ::platform::drbd::trigger_resize_check
}

class platform::drbd::dockerdistribution::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::dockerdistribution
  include ::platform::drbd::trigger_resize_check
}

class platform::drbd::cephmon::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::cephmon
}

class platform::drbd::rookmon::runtime {
  include ::platform::drbd::params
  include ::platform::drbd::runtime_service_enable
  include ::platform::drbd::rookmon
}
