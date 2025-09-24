# == Class: ceilometer::agent::compute
#
# The ceilometer::agent::compute class installs the ceilometer compute agent
# Include this class on all nova compute nodes
#
# === Parameters:
#
# [*enabled*]
#   (Optional) Should the service be enabled.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional)  Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'.
#
# [*instance_discovery_method*]
#   (Optional) method to discovery instances running on compute node
#   Defaults to $::os_service_default
#    * naive: poll nova to get all instances
#    * workload_partitioning: poll nova to get instances of the compute
#    * libvirt_metadata: get instances from libvirt metadata
#      but without instance metadata (recommended for Gnocchi backend).
#
class ceilometer::agent::compute (
  $manage_service            = true,
  $enabled                   = true,
  $package_ensure            = 'present',
  $instance_discovery_method = $::os_service_default,
) inherits ceilometer {

  warning('This class is deprecated. Please use ceilometer::agent::polling with compute namespace instead.')

  include ::ceilometer::params

  ceilometer_config {
    'compute/instance_discovery_method': value => $instance_discovery_method,
  }

  Ceilometer_config<||> ~> Service['ceilometer-agent-compute']

  Package['ceilometer-agent-compute'] -> Service['ceilometer-agent-compute']
  package { 'ceilometer-agent-compute':
    ensure => $package_ensure,
    name   => $::ceilometer::params::agent_compute_package_name,
    tag    => ['openstack', 'ceilometer-package'],
  }

  if $::ceilometer::params::libvirt_group {
    User['ceilometer'] {
      groups => ['nova', $::ceilometer::params::libvirt_group]
    }
    Package <| title == 'libvirt' |> -> User['ceilometer']
  } else {
    User['ceilometer'] {
      groups => ['nova']
    }
  }
  Package <| title == 'ceilometer-common' |> -> User['ceilometer']

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  Package <| title == 'nova-common' |> -> Package['ceilometer-common'] -> Service['ceilometer-agent-compute']
  service { 'ceilometer-agent-compute':
    ensure     => $service_ensure,
    name       => $::ceilometer::params::agent_compute_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'ceilometer-service',
  }

}
