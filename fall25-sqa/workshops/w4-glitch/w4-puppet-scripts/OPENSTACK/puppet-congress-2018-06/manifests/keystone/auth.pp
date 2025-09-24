# == Class: congress::keystone::auth
#
# Configures congress user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for congress user.
#
# [*auth_name*]
#   Username for congress service. Defaults to 'congress'.
#
# [*email*]
#   Email for congress user. Defaults to 'congress@localhost'.
#
# [*tenant*]
#   Tenant for congress user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should congress endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'policy'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of 'congress'.
#
# [*service_description*]
#   (optional) Description of the service.
#   Default to 'congress policy Service'
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:1789')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:1789')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:1789')
#
class congress::keystone::auth (
  $password,
  $auth_name           = 'congress',
  $email               = 'congress@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'congress',
  $service_description = 'congress Policy Service',
  $service_type        = 'policy',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:1789',
  $admin_url           = 'http://127.0.0.1:1789',
  $internal_url        = 'http://127.0.0.1:1789',
) {

  include ::congress::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Anchor['congress::service::end']
  }

  if $configure_endpoint {
    Keystone_endpoint["${region}/${service_name}::${service_type}"]  ~> Anchor['congress::service::end']
  }

  keystone::resource::service_identity { 'congress':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
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
