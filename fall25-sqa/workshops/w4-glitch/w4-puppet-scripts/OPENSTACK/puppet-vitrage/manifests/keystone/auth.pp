# == Class: vitrage::keystone::auth
#
# Configures vitrage user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for vitrage user.
#
# [*auth_name*]
#   (Optional) Username for vitrage service.
#   Defaults to 'vitrage'.
#
# [*email*]
#   (Optional) Email for vitrage user.
#   Defaults to 'vitrage@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for vitrage user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should vitrage endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'rca'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'Root Cause Analysis Service'
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8999'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8999'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8999'
#
class vitrage::keystone::auth (
  $password,
  $auth_name           = 'vitrage',
  $email               = 'vitrage@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_description = 'Root Cause Analysis Service',
  $service_name        = undef,
  $service_type        = 'rca',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8999',
  $internal_url        = 'http://127.0.0.1:8999',
  $admin_url           = 'http://127.0.0.1:8999',
) {

  include vitrage::deps

  $real_service_name = pick($service_name, $auth_name)

  keystone::resource::service_identity { 'vitrage':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
