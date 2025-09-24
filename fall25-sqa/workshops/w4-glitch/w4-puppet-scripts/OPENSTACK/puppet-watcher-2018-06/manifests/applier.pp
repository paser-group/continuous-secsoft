# == Class: watcher::applier
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) The state of the package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) The state of the service
#   Defaults to 'true'.
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service.
#   Defaults to 'true'.
#
# [*applier_workers*]
#   (Optional) Number of workers for watcher applier service.
#   Defaults to $::os_service_default
#
# [*applier_conductor_topic*]
#   (Optional) The topic name used forcontrol events, this topic used
#   for rpc call
#   Defaults to $::os_service_default
#
# [*applier_status_topic*]
#   (Optional) The topic name used for status events, this topic is used
#   so as to notifythe others components of the system
#   Defaults to $::os_service_default
#
# [*applier_publisher_id*]
#   (Optional) The identifier used by watcher module on the message broker
#   Defaults to $::os_service_default
#
# [*applier_workflow_engine*]
#   (Optional) Select the engine to use to execute the workflow
#   Defaults to $::os_service_default
#
class watcher::applier (
  $package_ensure          = 'present',
  $enabled                 = true,
  $manage_service          = true,
  $applier_workers         = $::os_service_default,
  $applier_conductor_topic = $::os_service_default,
  $applier_status_topic    = $::os_service_default,
  $applier_publisher_id    = $::os_service_default,
  $applier_workflow_engine = $::os_service_default,
) {

  include ::watcher::params
  include ::watcher::deps

  package { 'watcher-applier':
    ensure => $package_ensure,
    name   => $::watcher::params::applier_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'watcher-applier':
    ensure     => $service_ensure,
    name       => $::watcher::params::applier_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['watcher-service'],
  }

  watcher_config {
    'watcher_applier/workers':          value => $applier_workers;
    'watcher_applier/conductor_topic':  value => $applier_conductor_topic;
    'watcher_applier/status_topic':     value => $applier_status_topic;
    'watcher_applier/publisher_id':     value => $applier_publisher_id;
    'watcher_applier/workflow_engine':  value => $applier_workflow_engine;
  }

}
