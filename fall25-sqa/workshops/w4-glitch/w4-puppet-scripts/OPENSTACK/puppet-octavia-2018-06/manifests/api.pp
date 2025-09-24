# Installs & configure the octavia service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*host*]
#   (optional) The octavia api bind address.
#   Defaults to '0.0.0.0'
#
# [*port*]
#   (optional) The octavia api port.
#   Defaults to '9876'
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*auth_strategy*]
#   (optional) set authentication mechanism
#   Defaults to 'keystone'
#
# [*api_handler*]
#   (optional) The handler that the API communicates with
#   Defaults to $::os_service_default
#
# [*sync_db*]
#   (optional) Run octavia-db-manage upgrade head on api nodes after installing the package.
#   Defaults to false
#
class octavia::api (
  $manage_service  = true,
  $enabled         = true,
  $package_ensure  = 'present',
  $host            = '0.0.0.0',
  $port            = '9876',
  $auth_strategy   = 'keystone',
  $api_handler     = $::os_service_default,
  $sync_db         = false,
) inherits octavia::params {

  include ::octavia::deps
  include ::octavia::policy
  include ::octavia::db

  if $auth_strategy == 'keystone' {
    include ::octavia::keystone::authtoken
  }

  package { 'octavia-api':
    ensure => $package_ensure,
    name   => $::octavia::params::api_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'octavia-api':
      ensure     => $service_ensure,
      name       => $::octavia::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => ['octavia-service', 'octavia-db-sync-service'],
    }
  }

  if $sync_db {
    include ::octavia::db::sync
  }

  octavia_config {
    'api_settings/bind_host'     : value => $host;
    'api_settings/bind_port'     : value => $port;
    'api_settings/auth_strategy' : value => $auth_strategy;
    'api_settings/api_handler'   : value => $api_handler;
  }

}
