# == Class: octavia::keystone::auth
#
# Configures octavia user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for octavia user.
#
# [*auth_name*]
#   Username for octavia service. Defaults to 'octavia'.
#
# [*email*]
#   Email for octavia user. Defaults to 'octavia@localhost'.
#
# [*tenant*]
#   Tenant for octavia user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should octavia endpoint be configured? Defaults to 'true'.
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
#   Type of service. Defaults to 'load-balancer'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'octavia'
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:9876')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:9876')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:9876')
#
class octavia::keystone::auth (
  $password,
  $auth_name           = 'octavia',
  $email               = 'octavia@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'octavia',
  $service_type        = 'load-balancer',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9876',
  $admin_url           = 'http://127.0.0.1:9876',
  $internal_url        = 'http://127.0.0.1:9876',
) {

  include ::octavia::deps

  keystone::resource::service_identity { 'octavia':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => 'Octavia Service',
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
