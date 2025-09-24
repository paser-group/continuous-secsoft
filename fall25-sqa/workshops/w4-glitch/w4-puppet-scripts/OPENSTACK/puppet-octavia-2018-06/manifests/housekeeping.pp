# Installs and configures the octavia housekeeping service
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
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*spare_check_interval*]
#   (optional) spare check interval in seconds.
#   Defaults to $::os_service_default
#
# [*spare_amphorae_pool_size*]
#   (optional) Number of spare amphorae.
#   Defaults to $::os_service_default
#
# [*cleanup_interval*]
#   (optional) DB cleanup interval in seconds.
#   Defaults to $::os_service_default
#
# [*amphora_expiry_age*]
#   (optional) Amphora expiry age in seconds.
#   Defaults to $::os_service_default
#
# [*load_balancer_expiry_age*]
#   (optional) Load balancer expiry age in seconds.
#   Defaults to $::os_service_default
#
# [*cert_interval*]
#   (optional) Certificate check interval in seconds.
#   Defaults to $::os_service_default
#
# [*cert_expiry_buffer*]
#   (optional) Seconds until certificate expiry.
#   Defaults to $::os_service_default
#
# [*cert_rotate_threads*]
#   (optional) Number of threads performing amphora certificate rotation.
#   Defaults to $::os_service_default
#
class octavia::housekeeping (
  $manage_service            = true,
  $enabled                   = true,
  $package_ensure            = 'present',
  $spare_check_interval      = $::os_service_default,
  $spare_amphorae_pool_size  = $::os_service_default,
  $cleanup_interval          = $::os_service_default,
  $amphora_expiry_age        = $::os_service_default,
  $load_balancer_expiry_age  = $::os_service_default,
  $cert_interval             = $::os_service_default,
  $cert_expiry_buffer        = $::os_service_default,
  $cert_rotate_threads       = $::os_service_default,
) inherits octavia::params {

  include ::octavia::deps

  package { 'octavia-housekeeping':
    ensure => $package_ensure,
    name   => $::octavia::params::housekeeping_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'octavia-housekeeping':
    ensure     => $service_ensure,
    name       => $::octavia::params::housekeeping_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['octavia-service'],
  }

  octavia_config {
    'house_keeping/spare_check_interval'       : value => $spare_check_interval;
    'house_keeping/spare_amphorae_pool_size'   : value => $spare_amphorae_pool_size;
    'house_keeping/cleanup_interval'           : value => $cleanup_interval;
    'house_keeping/amphora_expiry_age'         : value => $amphora_expiry_age;
    'house_keeping/load_balancer_expiry_age'   : value => $load_balancer_expiry_age;
    'house_keeping/cert_interval'              : value => $cert_interval;
    'house_keeping/cert_expiry_buffer'         : value => $cert_expiry_buffer;
    'house_keeping/cert_rotate_threads'        : value => $cert_rotate_threads;
  }
}
