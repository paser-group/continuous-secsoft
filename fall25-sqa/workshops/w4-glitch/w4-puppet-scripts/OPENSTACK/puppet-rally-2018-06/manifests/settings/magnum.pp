# == Class: rally::settings::magnum
#
# Configure Rally benchmarking settings for magnum
#
# === Parameters
#
# [*magnum_cluster_create_prepoll_delay*]
#   (Optional) # Time to sleep after creating a resource before polling for the status. (floating point value)
#   Defaults to $::os_service_default
#
# [*magnum_cluster_create_timeout*]
#   (Optional) Time to wait for magnum cluster to be created. (floating point value)
#   Defaults to $::os_service_default
#
# [*magnum_cluster_create_poll_interval*]
#   (Optional) Time interval between checks when waiting for cluster creation. (floating point value)
#   Defaults to $::os_service_default
#
class rally::settings::magnum (
  $magnum_cluster_create_prepoll_delay = $::os_service_default,
  $magnum_cluster_create_timeout       = $::os_service_default,
  $magnum_cluster_create_poll_interval = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/magnum_cluster_create_prepoll_delay': value => $magnum_cluster_create_prepoll_delay;
    'benchmark/magnum_cluster_create_timeout':       value => $magnum_cluster_create_timeout;
    'benchmark/magnum_cluster_create_poll_interval': value => $magnum_cluster_create_poll_interval;
  }
}
