# == Class: rally::settings::ironic
#
# Configure Rally benchmarking settings for Ironic
#
# === Parameters
#
# [*node_create_poll_interval*]
#   (Optional) Interval (in sec) between checks when waiting for node creation.
#   Defaults to $::os_service_default
#
class rally::settings::ironic (
  $node_create_poll_interval = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/ironic_node_create_poll_interval': value => $node_create_poll_interval;
  }
}
