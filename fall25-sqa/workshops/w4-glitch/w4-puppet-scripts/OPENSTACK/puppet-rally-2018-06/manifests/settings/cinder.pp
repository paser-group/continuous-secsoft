# == Class: rally::settings::cinder
#
# Configure Rally benchmarking settings for Cinder
#
# === Parameters
#
# [*volume_create_poll_interval*]
#   (Optional) Interval between checks when waiting for volume creation.
#   Defaults to $::os_service_default
#
# [*volume_create_prepoll_delay*]
#   (Optional) Time to sleep after creating a resource before polling for it
#   status
#   Defaults to $::os_service_default
#
# [*volume_create_timeout*]
#   (Optional) Time to wait for cinder volume to be created.
#   Defaults to $::os_service_default
#
# [*volume_delete_poll_interval*]
#   (Optional) Interval between checks when waiting for volume deletion.
#   Defaults to $::os_service_default
#
# [*volume_delete_timeout*]
#   (Optional) Time to wait for cinder volume to be deleted.
#   Defaults to $::os_service_default
#
class rally::settings::cinder (
  $volume_create_poll_interval = $::os_service_default,
  $volume_create_prepoll_delay = $::os_service_default,
  $volume_create_timeout       = $::os_service_default,
  $volume_delete_poll_interval = $::os_service_default,
  $volume_delete_timeout       = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/cinder_volume_create_poll_interval': value => $volume_create_poll_interval;
    'benchmark/cinder_volume_create_prepoll_delay': value => $volume_create_prepoll_delay;
    'benchmark/cinder_volume_create_timeout':       value => $volume_create_timeout;
    'benchmark/cinder_volume_delete_poll_interval': value => $volume_delete_poll_interval;
    'benchmark/cinder_volume_delete_timeout':       value => $volume_delete_timeout;
  }
}
