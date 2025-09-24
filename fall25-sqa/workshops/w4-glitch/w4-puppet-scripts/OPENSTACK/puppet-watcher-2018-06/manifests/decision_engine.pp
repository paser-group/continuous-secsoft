# == Class: watcher::decision_engine
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
# [*decision_engine_conductor_topic*]
#   (Optional) The topic name used forcontrol events, this topic used
#   for rpc call
#   Defaults to $::os_service_default
#
# [*decision_engine_status_topic*]
#   (Optional) The topic name used for status events, this topic is used
#   so as to notifythe others components of the system
#   Defaults to $::os_service_default
#
# [*decision_engine_notification_topics*]
#   (Optional) The topic names from which notification events will be
#   listened to (list value)
#   Defaults to $::os_service_default
#
# [*decision_engine_publisher_id*]
#   (Optional) The identifier used by watcher module on the message broker
#   Defaults to $::os_service_default
#
# [*decision_engine_workers*]
#   (Optional) The maximum number of threads that can be used to execute
#   strategies
#   Defaults to $::os_service_default
#
# [*planner*]
#   (Optional) The selected planner used to schedule the actions (string value)
#   Defaults to $::os_service_default
#
# [*weights*]
#   (Optional) Hash of weights used to schedule the actions (dict value).
#   The key is an action, value is an order number.
#   Defaults to $::os_service_default
#   Example:
#     { 'change_nova_service_state' => '2',
#       'migrate' => '3', 'nop' => '0', 'sleep' => '1' }
#
#
class watcher::decision_engine (
  $package_ensure                      = 'present',
  $enabled                             = true,
  $manage_service                      = true,
  $decision_engine_conductor_topic     = $::os_service_default,
  $decision_engine_status_topic        = $::os_service_default,
  $decision_engine_notification_topics = $::os_service_default,
  $decision_engine_publisher_id        = $::os_service_default,
  $decision_engine_workers             = $::os_service_default,
  $planner                             = $::os_service_default,
  $weights                             = $::os_service_default,
) {

  include ::watcher::params
  include ::watcher::deps

  if !is_service_default($weights) {
    validate_hash($weights)
    $weights_real = join(sort(join_keys_to_values($weights, ':')), ',')
  } else {
    $weights_real = $weights
  }

  if !is_service_default($decision_engine_notification_topics) or
    empty($decision_engine_notification_topics) {
    warning('$decision_engine_notification_topics needs to be an array')
    $decision_engine_notification_topics_real = any2array($decision_engine_notification_topics)
  } else {
    $decision_engine_notification_topics_real = $decision_engine_notification_topics
  }

  package { 'watcher-decision-engine':
    ensure => $package_ensure,
    name   => $::watcher::params::decision_engine_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'watcher-decision-engine':
    ensure     => $service_ensure,
    name       => $::watcher::params::decision_engine_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['watcher-service'],
  }

  watcher_config {
    'watcher_decision_engine/conductor_topic':     value => $decision_engine_conductor_topic;
    'watcher_decision_engine/status_topic':        value => $decision_engine_status_topic;
    'watcher_decision_engine/notification_topics': value => $decision_engine_notification_topics_real;
    'watcher_decision_engine/publisher_id':        value => $decision_engine_publisher_id;
    'watcher_decision_engine/max_workers':         value => $decision_engine_workers;
  }

  watcher_config {
    'watcher_planner/planner':          value => $planner;
    'watcher_planners.default/weights': value => $weights_real;
  }

}
