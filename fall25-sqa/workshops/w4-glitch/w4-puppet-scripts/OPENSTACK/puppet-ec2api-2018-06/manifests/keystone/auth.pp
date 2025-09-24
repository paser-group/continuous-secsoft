# == Class: ec2api::keystone::auth
#
# Configures ec2api user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for ec2api user.
#
# [*auth_name*]
#   Username for ec2api service. Defaults to 'ec2api'.
#
# [*email*]
#   Email for ec2api user. Defaults to 'ec2api@localhost'.
#
# [*tenant*]
#   Tenant for ec2api user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should ec2api endpoint be configured? Defaults to 'true'.
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
#   Type of service. Defaults to 'ec2api'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*service_description*]
#   (optional) Description of the service.
#   Defaults to the value of 'ec2api Service'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8788')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8788')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8788')
#
class ec2api::keystone::auth (
  $password,
  $auth_name           = 'ec2api',
  $email               = 'ec2api@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'ec2api',
  $service_description = 'The EC2 API Service',
  $service_type        = 'ec2api',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8788',
  $admin_url           = 'http://127.0.0.1:8788',
  $internal_url        = 'http://127.0.0.1:8788',
) inherits ::ec2api::params {

  include ::ec2api::deps

  validate_string($password)
  validate_string($auth_name)
  validate_string($email)
  validate_string($tenant)
  validate_bool($configure_endpoint)
  validate_bool($configure_user)
  validate_bool($configure_user_role)

  $real_service_name = pick($service_name, $auth_name)

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Anchor['ec2api::service::end']
  }

  if $configure_endpoint {
    Keystone_endpoint["${region}/${real_service_name}::${service_type}"]
    ~> Anchor['ec2api::service::end']
  }

  keystone::resource::service_identity { 'ec2api':
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
