# Installs the aodh notifier service
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
class aodh::notifier (
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
) {

  include ::aodh::deps
  include ::aodh::params

  ensure_resource( 'package', [$::aodh::params::notifier_package_name],
    { ensure => $package_ensure,
      tag    => ['openstack', 'aodh-package'] }
  )

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'aodh-notifier':
    ensure     => $service_ensure,
    name       => $::aodh::params::notifier_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'aodh-service',
  }
}
