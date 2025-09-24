# == Class: magnum::conductor
#
# Manages magnum conductor package and service
#
# === Parameters:
#
# [*enabled*]
#   (optional) Whether to enable the magnum-conductor service
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*package_ensure*]
#   (optional) The state of the magnum conductor package
#   Defaults to 'present'
#
# [*conductor_life_check_timeout*]
#   (optional) RPC timeout for the conductor liveness check that is
#    used for bay locking.
#    Defaults to $::os_service_default
#
class magnum::conductor(
  $enabled                      = true,
  $manage_service               = true,
  $package_ensure               = 'present',
  $conductor_life_check_timeout = $::os_service_default,
) {

  include ::magnum::db
  include ::magnum::deps
  include ::magnum::params

  # Install package
  package { 'magnum-conductor':
    ensure => $package_ensure,
    name   => $::magnum::params::conductor_package,
    tag    => ['openstack', 'magnum-package']
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  # Manage service
  service { 'magnum-conductor':
    ensure    => $service_ensure,
    name      => $::magnum::params::conductor_package,
    enable    => $enabled,
    hasstatus => true,
    tag       => ['magnum-service', 'magnum-db-sync-service'],
  }

  magnum_config {
    'conductor/conductor_life_check_timeout': value => $conductor_life_check_timeout;
  }
}
