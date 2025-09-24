# == Class: magnum::keystone::auth
#
# Configures magnum user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for magnum user.
#
# [*auth_name*]
#   Username for magnum service. Defaults to 'magnum'.
#
# [*email*]
#   Email for magnum user. Defaults to 'magnum@localhost'.
#
# [*tenant*]
#   Tenant for magnum user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should magnum endpoint be configured? Defaults to 'true'.
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
#   Type of service. Defaults to 'container-infra'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:9511/v1')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:9511/v1')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:9511/v1')
#
class magnum::keystone::auth (
  $password,
  $auth_name           = 'magnum',
  $email               = 'magnum@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = undef,
  $service_type        = 'container-infra',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9511/v1',
  $admin_url           = 'http://127.0.0.1:9511/v1',
  $internal_url        = 'http://127.0.0.1:9511/v1',
) {

  include ::magnum::deps

  $real_service_name = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'magnum-server' |>
  }
  Keystone_endpoint["${region}/${real_service_name}::${service_name}"]  ~> Service <| name == 'magnum-server' |>

  keystone::resource::service_identity { 'magnum':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => 'magnum Container Service',
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
