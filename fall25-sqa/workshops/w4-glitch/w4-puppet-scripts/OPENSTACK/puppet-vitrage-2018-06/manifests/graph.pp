# Installs the vitrage graph service
#
# == Params
#  [*enabled*]
#    (optional) Should the service be enabled.
#    Defaults to true.
#
#  [*manage_service*]
#    (optional)  Whether the service should be managed by Puppet.
#    Defaults to true.
#
#  [*package_ensure*]
#    (optional) ensure state for package.
#    Defaults to 'present'
#
class vitrage::graph (
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
) {

  include ::vitrage::deps
  include ::vitrage::params

  ensure_resource( 'package', [$::vitrage::params::graph_package_name],
    { ensure => $package_ensure,
      tag    => ['openstack', 'vitrage-package'] }
  )

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  Package['vitrage'] -> Service['vitrage-graph']
  service { 'vitrage-graph':
    ensure     => $service_ensure,
    name       => $::vitrage::params::graph_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'vitrage-service',
  }
}
