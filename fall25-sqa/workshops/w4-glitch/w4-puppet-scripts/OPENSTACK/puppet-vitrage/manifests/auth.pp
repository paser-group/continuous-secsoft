# The vitrage::auth class helps configure auth settings
#
# == Parameters
# [*auth_url*]
#   (Optional) The keystone public endpoint
#   Defaults to 'http://localhost:5000/v3'
#
# [*auth_region*]
#   (Optional) The keystone region of this node
#   Defaults to 'RegionOne'
#
# [*auth_user*]
#   (Optional) The keystone user for vitrage services
#   Defaults to 'vitrage'
#
# [*auth_password*]
#   (Required) The keystone password for vitrage services
#
# [*auth_project_name*]
#   (Optional) The keystone tenant name for vitrage services
#   Defaults to 'services'
#
# [*project_domain_name*]
#   (Optional) The keystone project domain name for vitrage services
#   Defaults to 'Default'
#
# [*user_domain_name*]
#   (Optional) The keystone user domain id name vitrage services
#   Defaults to 'Default'
#
# [*auth_type*]
#   (Optional) An authentication type to use with an OpenStack Identity server.
#   The value should contain auth plugin name.
#   Defaults to 'password'.
#
# [*auth_cacert*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to $::os_service_default.
#
# [*interface*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*auth_endpoint_type*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
# [*auth_tenant_name*]
#   the keystone tenant name for vitrage services
#   Optional. Defaults to undef.
#
# [*auth_tenant_id*]
#   (Optional) The keystone tenant id for vitrage services.
#   Defaults to undef..
#
# [*project_domain_id*]
#   (Optional) The keystone project domain id for vitrage services
#   Defaults to 'default'
#
# [*user_domain_id*]
#   (Optional) The keystone user domain id for vitrage services
#   Defaults to 'default'
#
class vitrage::auth (
  $auth_password,
  $auth_url             = 'http://localhost:5000/v3',
  $auth_region          = 'RegionOne',
  $auth_user            = 'vitrage',
  $auth_project_name    = 'services',
  $project_domain_name  = 'Default',
  $user_domain_name     = 'Default',
  $auth_type            = 'password',
  $auth_cacert          = $::os_service_default,
  $interface            = $::os_service_default,
  # DEPRECATED PARAMETERS
  $auth_endpoint_type   = undef,
  $auth_tenant_name     = undef,
  $auth_tenant_id       = undef,
  $project_domain_id    = undef,
  $user_domain_id       = undef,
) {

  include vitrage::deps

  if $auth_endpoint_type != undef {
    warning('auth_endpoint_type is deprecated and will be removed in a future release. \
Use interface instead')
    $interface_real = $auth_endpoint_type
  } else {
    $interface_real = $interface
  }

  if $auth_tenant_name != undef {
    warning('auth_tenant_name is deprecated and will be removed in a future release. \
Use auth_project_name instead')
    $auth_project_name_real = $auth_tenant_name
  } else {
    $auth_project_name_real = $auth_project_name
  }

  if $auth_tenant_id != undef {
    warning('auth_tenant_id is deprecated and has no effect. Use auth_project_name instead.')
  }

  vitrage_config {
    'service_credentials/auth_url'          : value => $auth_url;
    'service_credentials/region_name'       : value => $auth_region;
    'service_credentials/username'          : value => $auth_user;
    'service_credentials/password'          : value => $auth_password, secret => true;
    'service_credentials/project_name'      : value => $auth_project_name_real;
    'service_credentials/cacert'            : value => $auth_cacert;
    'service_credentials/interface'         : value => $interface_real;
    'service_credentials/auth_type'         : value => $auth_type;
  }

  if $project_domain_id != undef {
    warning('vitrage::auth::project_domain_id is deprecated and will be removed \
in a future release. Use project_domain_name instead.')
    vitrage_config{
      'service_credentials/project_domain_id' : value => $project_domain_id;
    }
  } else {
    vitrage_config{
      'service_credentials/project_domain_name' : value => $project_domain_name;
    }
  }

  if $user_domain_id != undef {
    warning('vitrage::auth::user_domain_id is deprecated and will be removed \
in a future release. Use user_domain_name instead.')
    vitrage_config{
      'service_credentials/user_domain_id' : value => $user_domain_id;
    }
  } else {
    vitrage_config{
      'service_credentials/user_domain_name' : value => $user_domain_name;
    }
  }

}
