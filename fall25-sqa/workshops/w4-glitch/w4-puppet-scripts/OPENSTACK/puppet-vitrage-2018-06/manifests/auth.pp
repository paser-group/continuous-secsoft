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
#  [*auth_tenant_name*]
#    the keystone tenant name for vitrage services
#    Optional. Defaults to 'services'
#
#  [*project_domain_id*]
#    the keystone project domain id for vitrage services
#    Optional. Defaults to 'default'
#
#  [*user_domain_id*]
#    the keystone user domain id for vitrage services
#    Optional. Defaults to 'default'
#
#  [*auth_tenant_id*]
#    the keystone tenant id for vitrage services.
#    Optional. Defaults to $::os_service_default.
#
#  [*auth_type*]
#    An authentication type to use with an OpenStack Identity server.
#    The value should contain auth plugin name.
#    Optional. Defaults to 'password'.
#
# [*auth_cacert*]
#   (Optional) Certificate chain for SSL validation.
#   Defaults to $::os_service_default.
#
# [*auth_endpoint_type*]
#   (Optional) Type of endpoint in Identity service catalog to use for
#   communication with OpenStack services.
#   Defaults to $::os_service_default.
#
class vitrage::auth (
  $auth_password,
  $auth_url           = 'http://localhost:5000/v3',
  $auth_region        = 'RegionOne',
  $auth_user          = 'vitrage',
  $auth_tenant_name   = 'services',
  $project_domain_id  = 'default',
  $user_domain_id     = 'default',
  $auth_type          = 'password',
  $auth_tenant_id     = $::os_service_default,
  $auth_cacert        = $::os_service_default,
  $auth_endpoint_type = $::os_service_default,
) {

  include ::vitrage::deps

  vitrage_config {
    'service_credentials/auth_url'          : value => $auth_url;
    'service_credentials/region_name'       : value => $auth_region;
    'service_credentials/username'          : value => $auth_user;
    'service_credentials/password'          : value => $auth_password, secret => true;
    'service_credentials/project_name'      : value => $auth_tenant_name;
    'service_credentials/cacert'            : value => $auth_cacert;
    'service_credentials/tenant_id'         : value => $auth_tenant_id;
    'service_credentials/endpoint_type'     : value => $auth_endpoint_type;
    'service_credentials/project_domain_id' : value => $project_domain_id;
    'service_credentials/user_domain_id'    : value => $user_domain_id;
    'service_credentials/auth_type'         : value => $auth_type;
  }

}
