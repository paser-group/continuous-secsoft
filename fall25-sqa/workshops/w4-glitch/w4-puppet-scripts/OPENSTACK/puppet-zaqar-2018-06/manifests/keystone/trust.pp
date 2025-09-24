# == Class: zaqar::keystone::trust
#
# Configures zaqar trust notifier.
#
# === Parameters
#
# [*username*]
#   (Optional) The name of the trust user
#   Defaults to 'zaqar'
#
# [*password*]
#   (Optional) Password to create for the trust user
#   Defaults to $::os_service_default
#
# [*auth_url*]
#   (Optional) The URL to use for authentication.
#   Defaults to 'http://localhost:35357'
#
# [*user_domain_name*]
#   (Optional) Name of domain for $username
#   Defaults to 'Default'
#
# [*auth_section*]
#   (Optional) Config Section from which to load plugin specific options
#   Defaults to $::os_service_default.
#
# [*auth_type*]
#   (Optional) Authentication type to load
#   Defaults to 'password'
#
class zaqar::keystone::trust(
  $username                       = 'zaqar',
  $password                       = $::os_service_default,
  $auth_url                       = 'http://localhost:35357',
  $user_domain_name               = 'Default',
  $auth_section                   = $::os_service_default,
  $auth_type                      = 'password',
) {

  include ::zaqar::deps

  zaqar_config {
    'trustee/username': value => $username;
    'trustee/password': value => $password;
    'trustee/user_domain_name': value => $user_domain_name;
    'trustee/auth_url': value => $auth_url;
    'trustee/auth_section': value => $auth_section;
    'trustee/auth_type': value => $auth_type;
  }

}
