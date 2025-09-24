# Installs the vitrage notifier service
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
#  [*notifiers*]
#    (optional) Names of enabled notifiers.
#    Defaults to $::os_service_default.
#
class vitrage::notifier (
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $notifiers      = $::os_service_default,
) {

  include vitrage::deps
  include vitrage::params

  if !is_service_default($notifiers) {
    $notifiers_orig = join(any2array($notifiers), ',')
  } else {
    $notifiers_orig = $notifiers
  }

  ensure_resource( 'package', [$::vitrage::params::notifier_package_name],
    { ensure => $package_ensure,
      tag    => ['openstack', 'vitrage-package'] }
  )

  vitrage_config {
    'DEFAULT/notifiers': value => $notifiers_orig;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  Package['vitrage'] -> Service['vitrage-notifier']
  service { 'vitrage-notifier':
    ensure     => $service_ensure,
    name       => $::vitrage::params::notifier_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'vitrage-service',
  }
}
