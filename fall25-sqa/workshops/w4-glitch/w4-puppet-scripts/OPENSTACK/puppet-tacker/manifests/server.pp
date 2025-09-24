# = Class: tacker::server
#
# This class manages the Tacker server.
#
# [*enabled*]
#   (Optional) Service enable state for tacker-server.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the service is managed by this puppet class.
#   Defaults to true.
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*bind_host*]
#   (optional) The host IP to bind to.
#   Defaults to $::os_service_default
#
# [*bind_port*]
#   (optional) The port to bind to.
#   Defaults to $::os_service_default
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'
#
class tacker::server(
  $manage_service = true,
  $enabled        = true,
  $auth_strategy  = 'keystone',
  $bind_host      = $::os_service_default,
  $bind_port      = $::os_service_default,
  $package_ensure = 'present',
) {

  include tacker::deps
  include tacker::params
  include tacker::policy

  if $auth_strategy == 'keystone' {
    include tacker::keystone::authtoken
  }

  package { 'tacker-server':
    ensure => $package_ensure,
    name   => $::tacker::params::package_name,
    tag    => ['openstack', 'tacker-package'],
  }

  tacker_config {
    'DEFAULT/bind_host' : value => $bind_host;
    'DEFAULT/bind_port' : value => $bind_port;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $manage_service {
    service { 'tacker-server':
      ensure => $service_ensure,
      name   => $::tacker::params::service_name,
      enable => $enabled,
      tag    => 'tacker-service'
    }
  }

}
