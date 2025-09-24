# == Class: rally::settings::ec2
#
# Configure Rally benchmarking settings for EC2
#
# === Parameters
#
# [*server_boot_poll_interval*]
#   (Optional) Server boot poll interval
#   Defaults to $::os_service_default
#
# [*server_boot_prepoll_delay*]
#   (Optional) Time to sleep after boot before polling for status
#   Defaults to $::os_service_default
#
# [*server_boot_timeout*]
#   (Optional) Server boot timeout
#   Defaults to $::os_service_default
#
class rally::settings::ec2 (
  $server_boot_poll_interval = $::os_service_default,
  $server_boot_prepoll_delay = $::os_service_default,
  $server_boot_timeout       = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/ec2_server_boot_poll_interval': value => $server_boot_poll_interval;
    'benchmark/ec2_server_boot_prepoll_delay': value => $server_boot_prepoll_delay;
    'benchmark/ec2_server_boot_timeout':       value => $server_boot_timeout;
  }
}
