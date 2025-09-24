#
# Copyright 2016 6WIND S.A.

class virtual_accelerator::config inherits virtual_accelerator {

  $advanced_params = $virtual_accelerator::advanced_params

  file { '/etc/init/cpu-cgroup.conf':
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    source => 'puppet:///modules/virtual_accelerator/cpu-cgroup.conf',
  } ->
  service { 'cpu-cgroup':
    ensure => 'running',
  }

  $fp_conf_file = "/usr/local/etc/fast-path.env"
  $hugepages_dir = "/dev/hugepages"
  $license_file = $virtual_accelerator::va_license_file

  exec { 'copy_template':
    command => "cp /usr/local/etc/fast-path.env.tmpl ${fp_conf_file}",
  } ->
  exec { 'set_hugepages_dir':
    command => "config_va.sh HUGEPAGES_DIR ${hugepages_dir}",
    path    => '/usr/local/bin/',
  }

  if $license_file != '' and $license_file != undef {
    file {"/usr/local/etc/6wind_va.lic":
      ensure  => file,
      content => $license_file,
    }
  }

  if $advanced_params == true {
    $custom_conf_file = $virtual_accelerator::va_conf_file

    if $custom_conf_file != '' and $custom_conf_file != undef {
      exec {'remove_old_conf':
        command  => "rm ${fp_conf_file}",
        require  => Exec['set_fp_mem'],
      } ->
      file {"${fp_conf_file}":
        ensure  => file,
        content => $custom_conf_file,
      }
    }
    else {
      $vm_mem = $virtual_accelerator::vm_mem
      $fp_mem = $virtual_accelerator::fp_mem

      exec { 'set_vm_mem':
        command => "config_va.sh VM_MEMORY ${vm_mem}",
        path    => '/usr/local/bin/',
      } ->
      exec { 'set_fp_mem':
        command => "config_va.sh FP_MEMORY ${fp_mem}",
        path    => '/usr/local/bin/',
      }
    }
  }

}
