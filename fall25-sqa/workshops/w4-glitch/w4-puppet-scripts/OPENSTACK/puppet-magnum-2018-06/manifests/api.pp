# == Class: magnum::api
#
# Setup and configure the Magnum API endpoint
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Sets the ensure parameter for the package resource.
#   Defaults to 'present'
#
# [*enabled*]
#   (Optional) Define if the service should be enabled or not.
#   Defaults to true
#
# [*port*]
#   (Optional) The port for the Magnum API server.
#   Defaults to '9511'
#
# [*host*]
#   (Optional) The listen IP for the Magnum API server.
#   Defaults to '127.0.0.1'
#
# [*max_limit*]
#   (Optional) The maximum number of items returned in a single response
#   from a collection resource.
#   Defaults to '1000'
#
# [*sync_db*]
#   (Optional) Enable DB sync
#   Defaults to true
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*enabled_ssl*]
#   (Optional) Whether to use ssl or not.
#   Defaults to 'false'.
#
# [*ssl_cert_file*]
#   (Optional) Location of the SSL certificate file to use for SSL mode.
#   Required when $enabled_ssl is set to 'true'.
#   Defaults to $::os_service_default.
#
# [*ssl_key_file*]
#   (Optional) Location of the SSL key file to use for enabling SSL mode.
#   Required when $enabled_ssl is set to 'true'.
#   Defaults to $::os_service_default.
#
class magnum::api(
  $package_ensure = 'present',
  $enabled        = true,
  $port           = '9511',
  $host           = '127.0.0.1',
  $max_limit      = '1000',
  $sync_db        = true,
  $auth_strategy  = 'keystone',
  $enabled_ssl    = false,
  $ssl_cert_file  = $::os_service_default,
  $ssl_key_file   = $::os_service_default,
) {

  include ::magnum::deps
  include ::magnum::params
  include ::magnum::policy

  if $enabled_ssl {
    if is_service_default($ssl_cert_file) {
      fail('The ssl_cert_file parameter is required when enabled_ssl is true')
    }
    if is_service_default($ssl_key_file) {
      fail('The ssl_key_file parameter is required when enabled_ssl is true')
    }
  }

  if $sync_db {
    include ::magnum::db::sync
  }

  # Configure API conf
  magnum_config {
    'api/port' :         value => $port;
    'api/host' :         value => $host;
    'api/max_limit' :    value => $max_limit;
    'api/enabled_ssl':   value => $enabled_ssl;
    'api/ssl_cert_file': value => $ssl_cert_file;
    'api/ssl_key_file':  value => $ssl_key_file;
  }

  # Install package
  if $::magnum::params::api_package {
    package { 'magnum-api':
      ensure => $package_ensure,
      name   => $::magnum::params::api_package,
      tag    => ['openstack', 'magnum-package'],
    }
  }

  if $enabled {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  # Manage service
  service { 'magnum-api':
    ensure    => $ensure,
    name      => $::magnum::params::api_service,
    enable    => $enabled,
    hasstatus => true,
    tag       => ['magnum-service', 'magnum-db-sync-service'],
  }

  if $auth_strategy == 'keystone' {
    include ::magnum::keystone::authtoken
  }
}
