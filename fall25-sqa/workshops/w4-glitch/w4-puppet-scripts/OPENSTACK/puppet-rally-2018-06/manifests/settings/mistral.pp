# == Class: rally::settings::mistral
#
# Configure Rally benchmarking settings for mistral
#
# === Parameters
#
# [*mistral_execution_timeout*]
#   (Optional) mistral execution timeout (integer value).
#   Defaults to $::os_service_default
#
class rally::settings::mistral (
  $mistral_execution_timeout = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/mistral_execution_timeout': value => $mistral_execution_timeout;
  }
}
