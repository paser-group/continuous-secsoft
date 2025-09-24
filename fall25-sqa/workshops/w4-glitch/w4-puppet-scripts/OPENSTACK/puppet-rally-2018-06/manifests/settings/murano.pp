# == Class: rally::settings::murano
#
# Configure Rally benchmarking settings for Murano
#
# === Parameters
#
# [*deploy_environment_check_interval*]
#   (Optional) Deploy environment check interval in seconds
#   Defaults to $::os_service_default
#
# [*deploy_environment_timeout*]
#   (Optional) A timeout in seconds for an environment deploy
#   Defaults to $::os_service_default
#
class rally::settings::murano (
  $deploy_environment_check_interval = $::os_service_default,
  $deploy_environment_timeout        = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/murano_deploy_environment_check_interval':  value => $deploy_environment_check_interval;
    'benchmark/murano_deploy_environment_timeout':         value => $deploy_environment_timeout;
  }
}
