# == Class qdr::config
#
# This class is called from qdr for qdrouterd service configuration
#
class qdr::config inherits qdr {

  $service_config_path     = $::qdr::params::service_config_path
  $service_home            = $::qdr::params::service_home
  $log_output              = $::qdr::log_output
  $router_debug_dump       = $::qdr::router_debug_dump
  $service_config_template = 'qdr/qdrouterd.conf.erb'

  file { $service_home :
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
  }

  file { '/etc/qpid-dispatch' :
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }

  file { '/etc/qpid-dispatch/ssl' :
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }

  file { 'qdrouterd.conf' :
    ensure  => file,
    path    => $service_config_path,
    content => template($service_config_template),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['qdr::service'],
  }

  file { $router_debug_dump :
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0766',
  }

  file { $log_output :
    ensure => file,
    owner  => '0',
    group  => '0',
    mode   => '0666',
  }

}
