# == Class: rally::settings::monasca
#
# Configure Rally benchmarking settings for monasca
#
# === Parameters
#
# [*monasca_metric_create_prepoll_delay*]
#   (Optional) Interval (in sec) between checks when waiting for node creation.
#   Defaults to $::os_service_default
#
class rally::settings::monasca (
  $monasca_metric_create_prepoll_delay = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/monasca_metric_create_prepoll_delay': value => $monasca_metric_create_prepoll_delay;
  }
}
