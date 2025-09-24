# == Class: octavia::quota
#
# Setup and configure octavia quotas.
#
# === Parameters:
#
# [*load_balancer_quota*]
#   (optional) Default per project load balancer quota
#   Defaults to $::os_service_default
#
# [*listener_quota*]
#   (optional) Default per project listener quota.
#   Defaults to $::os_service_default
#
# [*member_quota*]
#   (optional)  Default per project member quota.
#   Defaults to $::os_service_default
#
# [*pool_quota*]
#   (optional)  Default per project pool quota.
#   Defaults to $::os_service_default
#
# [*health_monitor_quota*]
#   (optional) Default per project health monitor quota.
#   Defaults to $::os_service_default
#
class octavia::quota (
  $load_balancer_quota   = $::os_service_default,
  $listener_quota        = $::os_service_default,
  $member_quota          = $::os_service_default,
  $pool_quota            = $::os_service_default,
  $health_monitor_quota  = $::os_service_default,
) {

  include ::octavia::deps

  octavia_config {
    'quotas/default_load_balancer_quota':  value => $load_balancer_quota;
    'quotas/default_listener_quota':       value => $listener_quota;
    'quotas/default_member_quota':         value => $member_quota;
    'quotas/default_pool_quota':           value => $pool_quota;
    'quotas/default_health_monitor_quota': value => $health_monitor_quota;
  }
}
