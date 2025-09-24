# == Class: rally
#
# This class is used to specify configuration default section parameters in rally.
#
# === Parameters:
#
# [*package_ensure*]
#   (optional) The state of rally packages
#   Defaults to 'present'.
#
# [*rally_debug*]
#   (optional) Print debugging output only for Rally. (boolean value)
#   Defaults to $::os_service_default.
#
# [*openstack_client_http_timeout*]
#   (optional) HTTP timeout for any of OpenStack service in seconds (floating point value)
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the rally config.
#   Defaults to false.
#
# [*sync_db*]
#   (Optional) Run db sync on the node.
#   Defaults to true.
#
class rally (
  $package_ensure                = 'present',
  $rally_debug                   = $::os_service_default,
  $openstack_client_http_timeout = $::os_service_default,
  $purge_config                  = false,
  $sync_db                       = true,
) inherits ::rally::params {

  include ::rally::deps
  include ::rally::db
  include ::rally::logging
  include ::rally::settings

  # Keep backward compatibility
  $openstack_client_http_timeout_real = pick($::rally::settings::openstack_client_http_timeout,$openstack_client_http_timeout)

  package { 'rally':
    ensure => $package_ensure,
    name   => $::rally::params::package_name,
    tag    => ['openstack', 'rally-package'],
  }

  resources { 'rally_config':
    purge => $purge_config,
  }

  if $sync_db {
    include ::rally::db::sync
  }

  rally_config {
    'DEFAULT/rally_debug':                   value => $rally_debug;
    'DEFAULT/openstack_client_http_timeout': value => $openstack_client_http_timeout;
  }
}
