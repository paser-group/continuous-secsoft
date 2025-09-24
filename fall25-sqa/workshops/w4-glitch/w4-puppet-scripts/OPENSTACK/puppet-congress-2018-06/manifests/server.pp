# = Class: congress::server
#
# This class manages the Congress server.
#
# [*enabled*]
#   (Optional) Service enable state for congress-server.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the service is managed by this puppet class.
#   Defaults to true.
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*bind_host*]
#   (optional) The host IP to bind to.
#   Defaults to $::os_service_default
#
# [*bind_port*]
#   (optional) The port to bind to.
#   Defaults to $::os_service_default
#
class congress::server(
  $manage_service = true,
  $enabled        = true,
  $auth_strategy  = 'keystone',
  $bind_host      = $::os_service_default,
  $bind_port      = $::os_service_default,
) {

  include ::congress::deps
  include ::congress::params
  include ::congress::policy

  if $auth_strategy == 'keystone' {
    include ::congress::keystone::authtoken
  }

  congress_config {
    'DEFAULT/bind_host' : value => $bind_host;
    'DEFAULT/bind_port' : value => $bind_port;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $manage_service {
    service { 'congress-server':
      ensure => $service_ensure,
      name   => $::congress::params::service_name,
      enable => $enabled,
      tag    => 'congress-service'
    }
  }

}
