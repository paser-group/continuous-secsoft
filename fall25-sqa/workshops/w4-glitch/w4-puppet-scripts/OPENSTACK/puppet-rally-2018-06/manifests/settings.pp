# == Class: rally::settings
#
# Configure Rally benchmarking settings
#
# === Parameters
#
# [*project_domain*]
#   (Optional) ID of domain in which projects will be created.
#   Defaults to $::os_service_default
#
# [*resource_deletion_timeout*]
#   (Optional) A timeout in seconds for deleting resources
#   Defaults to $::os_service_default
#
# [*resource_management_workers*]
#   (Optional) How many concurrent threads use for serving users context
#   Defaults to $::os_service_default
#
# [*user_domain*]
#   (Optional) ID of domain in which users will be created.
#   Defaults to $::os_service_default
#
# [*openstack_client_http_timeout*]
#   (optional) HTTP timeout for any of OpenStack service in seconds (floating point value)
#   Defaults to undef.
#
class rally::settings (
  $project_domain                = $::os_service_default,
  $resource_deletion_timeout     = $::os_service_default,
  $resource_management_workers   = $::os_service_default,
  $user_domain                   = $::os_service_default,
  $openstack_client_http_timeout = undef,
) {

  include ::rally::deps
  include ::rally::settings::cinder
  include ::rally::settings::ec2
  include ::rally::settings::glance
  include ::rally::settings::heat
  include ::rally::settings::ironic
  include ::rally::settings::manila
  include ::rally::settings::murano
  include ::rally::settings::nova
  include ::rally::settings::sahara
  include ::rally::settings::swift
  include ::rally::settings::tempest
  include ::rally::settings::magnum
  include ::rally::settings::mistral
  include ::rally::settings::monasca
  include ::rally::settings::watcher

  rally_config {
    'cleanup/resource_deletion_timeout':         value => $resource_deletion_timeout;
    'users_context/project_domain':              value => $project_domain;
    'users_context/resource_management_workers': value => $resource_management_workers;
    'users_context/user_domain':                 value => $user_domain;
  }
}
