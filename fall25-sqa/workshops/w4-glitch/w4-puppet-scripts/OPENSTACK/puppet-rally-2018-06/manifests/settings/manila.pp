# == Class: rally::settings::manila
#
# Configure Rally benchmarking settings for Manila
#
# === Parameters
#
# [*share_create_poll_interval*]
#   (Optional) Interval between checks when waiting for Manila share creation.
#   Defaults to $::os_service_default
#
# [*share_create_prepoll_delay*]
#   (Optional) Delay between creating Manila share and polling for its status.
#   Defaults to $::os_service_default
#
# [*share_create_timeout*]
#   (Optional) Timeout for Manila share creation.
#   Defaults to $::os_service_default
#
# [*share_delete_poll_interval*]
#   (Optional) Interval between checks when waiting for Manila share deletion.
#   Defaults to $::os_service_default
#
# [*share_delete_timeout*]
#   (Optional) Timeout for Manila share deletion.
#   Defaults to $::os_service_default
#
class rally::settings::manila (
  $share_create_poll_interval = $::os_service_default,
  $share_create_prepoll_delay = $::os_service_default,
  $share_create_timeout       = $::os_service_default,
  $share_delete_poll_interval = $::os_service_default,
  $share_delete_timeout       = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/manila_share_create_poll_interval':         value => $share_create_poll_interval;
    'benchmark/manila_share_create_prepoll_delay':         value => $share_create_prepoll_delay;
    'benchmark/manila_share_create_timeout':               value => $share_create_timeout;
    'benchmark/manila_share_delete_poll_interval':         value => $share_delete_poll_interval;
    'benchmark/manila_share_delete_timeout':               value => $share_delete_timeout;
  }
}
