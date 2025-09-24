# Installs the aodh evaluator service
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
#  [*coordination_url*]
#    (optional) The url to use for distributed group membership coordination.
#    Defaults to undef.
#
#  [*evaluation_interval*]
#    (optional) Period of evaluation cycle
#    Defaults to $::os_service_default.
#
class aodh::evaluator (
  $manage_service      = true,
  $enabled             = true,
  $package_ensure      = 'present',
  $coordination_url    = undef,
  $evaluation_interval = $::os_service_default,
) {

  include ::aodh::deps
  include ::aodh::params

  aodh_config {
    'DEFAULT/evaluation_interval' : value => $evaluation_interval;
  }
  if $coordination_url {
    aodh_config {
      'coordination/backend_url' : value => $coordination_url;
    }
    if ($coordination_url =~ /^redis/ ) {
      ensure_resource('package', 'python-redis', {
        name   => $::aodh::params::redis_package_name,
        tag    => 'openstack',
      })
    }
  }

  ensure_resource( 'package', [$::aodh::params::evaluator_package_name],
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

  service { 'aodh-evaluator':
    ensure     => $service_ensure,
    name       => $::aodh::params::evaluator_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['aodh-service','aodh-db-sync-service']
  }
}
