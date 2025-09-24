# == class: zaqar::messaging::swift
#
# [*uri*]
#   Swift Connection URI. Required.
#
# [*auth_url*]
#   URL to the KeyStone service. Default $::os_service_default
#
class zaqar::messaging::swift(
  $uri,
  $auth_url = $::os_service_default,
) {

  include ::zaqar::deps

  zaqar_config {
    'drivers:message_store:swift/uri':      value => $uri, secret => true;
    'drivers:message_store:swift/auth_url': value => $auth_url;
  }

}
