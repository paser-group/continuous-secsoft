class platform::collectd::params (
  $interval = undef,
  $timeout = undef,
  $read_threads = undef,
  $write_threads = undef,
  $write_queue_limit_high = undef,
  $write_queue_limit_low = undef,
  $server_addrs = [],
  $server_port = undef,
  $max_read_interval = undef,

  # python plugin controls
  $module_path = undef,
  $plugins = [],
  $log_traces = undef,
  $encoding = undef,

  $collectd_d_dir = undef,
) {}


class platform::collectd
  inherits ::platform::collectd::params {

  file { '/etc/collectd.conf':
    ensure  => 'present',
    replace => true,
    content => template('platform/collectd.conf.erb'),
  } # now start collectd

  -> exec { 'collectd-enable':
      command => 'systemctl enable collectd',
      unless  => 'systemctl is-enabled collectd'
  }

  # ensure pmon soft link for process monitoring
  -> file { '/etc/pmon.d/collectd.conf':
    ensure => 'link',
    target => '/opt/collectd/extensions/config/collectd.conf.pmon',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
}

class platform::collectd::runtime {
  include ::platform::collectd
}

# restart target
class platform::collectd::restart {
  include ::platform::collectd
  exec { 'collectd-restart':
      command => '/usr/local/sbin/pmon-restart collectd'
  }
}
