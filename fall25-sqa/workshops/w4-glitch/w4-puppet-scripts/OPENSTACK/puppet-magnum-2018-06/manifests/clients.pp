# == Class: magnum::clients
#
# Manages the clients configuration in magnum server
#
# === Parameters:
#
# [*region_name*]
#   (optional) Region in Identity service catalog to use for communication
#   with the OpenStack service.
#   Defaults to RegionOne
#
# [*endpoint_type*]
#   (optional) Type of endpoint in Identity service catalog to use for
#   communication with the OpenStack service.
#   Defaults to publicURL
#
# [*ca_file*]
#   (optional) CA cert file to use in SSL connections.
#   Defaults to $::os_service_default
#
# [*cert_file*]
#   (optional) PEM-formatted certificate chain file.
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) PEM-formatted file that contains the private key.
#   Defaults to $::os_service_default
#
# [*insecure*]
#   (optional) If set, then the server's certificate will not be verified.
#   Defaults to false
#
class magnum::clients (
  $region_name   = 'RegionOne',
  $endpoint_type = 'publicURL',
  $ca_file       = $::os_service_default,
  $cert_file     = $::os_service_default,
  $key_file      = $::os_service_default,
  $insecure      = false
) {
  include ::magnum::deps
  include ::magnum::params
  include ::magnum::clients::barbican
  include ::magnum::clients::cinder
  include ::magnum::clients::glance
  include ::magnum::clients::heat
  include ::magnum::clients::magnum
  include ::magnum::clients::neutron
  include ::magnum::clients::nova
}
