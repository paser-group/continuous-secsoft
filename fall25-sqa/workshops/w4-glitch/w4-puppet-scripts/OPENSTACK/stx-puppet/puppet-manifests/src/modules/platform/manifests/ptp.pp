class platform::ptp (
  $enabled = false,
  $ptp4l_options = [],
  $transport = 'L2',
  $phc2sys_options = '',
  $master_devices = [],
  $slave_devices = [],
  $runtime = false
) {
  if empty($master_devices) {
    $slave_only = true
  } else {
    $slave_only = false
  }

  if $enabled {
    $ensure = 'running'
    $enable = true
  } else {
    $ensure = 'stopped'
    $enable = false
  }

  if $runtime {
    # During runtime we set first_step_threshold to 0. This ensures there are no
    # large time changes to a running host
    $phc2sys_cmd_opts = "${phc2sys_options} -F 0"
  } else {
    $phc2sys_cmd_opts = $phc2sys_options
  }

  file { 'ptp4l_config':
    ensure  => file,
    path    => '/etc/ptp4l.conf',
    mode    => '0644',
    content => template('platform/ptp4l.conf.erb'),
    notify  => [ Service['phc2sys'], Service['ptp4l'] ],
  }
  -> file { 'ptp4l_service':
    ensure  => file,
    path    => '/etc/systemd/system/ptp4l.service',
    mode    => '0644',
    content => template('platform/ptp4l.service.erb'),
  }
  -> file { 'ptp4l_sysconfig':
    ensure  => file,
    path    => '/etc/sysconfig/ptp4l',
    mode    => '0644',
    content => template('platform/ptp4l.erb'),
  }
  -> file { 'phc2sys_service':
    ensure  => file,
    path    => '/etc/systemd/system/phc2sys.service',
    mode    => '0644',
    content => template('platform/phc2sys.service.erb'),
  }
  -> file { 'phc2sys_sysconfig':
    ensure  => file,
    path    => '/etc/sysconfig/phc2sys',
    mode    => '0644',
    content => template('platform/phc2sys.erb'),
    notify  => Service['phc2sys'],
  }
  -> exec { 'systemctl-daemon-reload':
    command => '/usr/bin/systemctl daemon-reload',
  }
  -> service { 'ptp4l':
    ensure     => $ensure,
    enable     => $enable,
    name       => 'ptp4l',
    hasstatus  => true,
    hasrestart => true,
  }
  -> service { 'phc2sys':
    ensure     => $ensure,
    enable     => $enable,
    name       => 'phc2sys',
    hasstatus  => true,
    hasrestart => true,
  }
  if $enabled {
    exec { 'enable-ptp4l':
      command => '/usr/bin/systemctl enable ptp4l.service',
      require => Service['phc2sys'],
    }
    -> exec { 'enable-phc2sys':
      command => '/usr/bin/systemctl enable phc2sys.service',
    }
  } else {
    exec { 'disable-ptp4l':
      command => '/usr/bin/systemctl disable ptp4l.service',
      require => Exec['systemctl-daemon-reload'],
    }
    -> exec { 'disable-phc2sys':
      command => '/usr/bin/systemctl disable phc2sys.service',
    }
    -> exec { 'stop-ptp4l':
      command => '/usr/bin/systemctl stop ptp4l.service',
    }
    -> exec { 'stop-phc2sys':
      command => '/usr/bin/systemctl stop phc2sys.service',
    }
  }
}

class platform::ptp::runtime {
  class { 'platform::ptp': runtime => true }
}
