# == Class: rally::settings::glance
#
# Configure Rally benchmarking settings for Glance
#
# === Parameters
#
# [*image_create_poll_interval*]
#   (Optional) Interval between checks when waiting for image creation.
#   Defaults to $::os_service_default
#
# [*image_create_prepoll_delay*]
#   (Optional) Time to sleep after creating a resource before polling for it
#   status
#   Defaults to $::os_service_default
#
# [*image_create_timeout*]
#   (Optional) Time to wait for glance image to be created.
#   Defaults to $::os_service_default
#
# [*image_delete_poll_interval*]
#   (Optional) Interval between checks when waiting for image deletion.
#   Defaults to $::os_service_default
#
# [*image_delete_timeout*]
#   (Optional) Time to wait for glance image to be deleted.
#   Defaults to $::os_service_default
#
class rally::settings::glance (
  $image_create_poll_interval = $::os_service_default,
  $image_create_prepoll_delay = $::os_service_default,
  $image_create_timeout       = $::os_service_default,
  $image_delete_poll_interval = $::os_service_default,
  $image_delete_timeout       = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/glance_image_create_poll_interval': value => $image_create_poll_interval;
    'benchmark/glance_image_create_prepoll_delay': value => $image_create_prepoll_delay;
    'benchmark/glance_image_create_timeout':       value => $image_create_timeout;
    'benchmark/glance_image_delete_poll_interval': value => $image_delete_poll_interval;
    'benchmark/glance_image_delete_timeout':       value => $image_delete_timeout;
  }
}
