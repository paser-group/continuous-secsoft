# == Class: zaqar::keystone::auth_websocket
#
# Configures zaqar-websocket user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for zaqar websocket user.
#
# [*auth_name*]
#   Username for zaqar service. Defaults to 'zaqar-websocket'.
#
# [*email*]
#   Email for zaqar websocket user. Defaults to 'zaqar-websocket@localhost'.
#
# [*tenant*]
#   Tenant for zaqar websocket user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should zaqar websocket endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'messaging'.
#
# [*public_url*]
#   (optional) The endpoint's public url.
#   (Defaults to 'ws://127.0.0.1:9000')
#
# [*internal_url*]
#   (optional) The endpoint's internal url.
#   (Defaults to 'ws://127.0.0.1:9000')
#
# [*admin_url*]
#   (optional) The endpoint's admin url.
#   (Defaults to 'ws://127.0.0.1:9000')
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'zaqar-websocket'
#
# [*configure_service*]
#   Should zaqar websocket service be configured? Defaults to 'true'.
#
# [*service_description*]
#   (optional) Description for keystone service.
#   Defaults to 'Openstack messaging websocket Service'.

# [*configure_user_role*]
#   (optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
class zaqar::keystone::auth_websocket(
  $password,
  $email                  = 'zaqar-websocket@localhost',
  $auth_name              = 'zaqar-websocket',
  $service_name           = 'zaqar-websocket',
  $service_type           = 'messaging-websocket',
  $public_url             = 'ws://127.0.0.1:9000',
  $admin_url              = 'ws://127.0.0.1:9000',
  $internal_url           = 'ws://127.0.0.1:9000',
  $region                 = 'RegionOne',
  $tenant                 = 'services',
  $configure_endpoint     = true,
  $configure_service      = true,
  $configure_user         = true,
  $configure_user_role    = true,
  $service_description    = 'Openstack messaging websocket Service',
) {

  include ::zaqar::deps

  validate_string($password)

  keystone::resource::service_identity { 'zaqar-websocket':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    auth_name           => $auth_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
