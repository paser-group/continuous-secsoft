# == Class: magnum::clients::nova
#
# Manages nova clients configuration in magnum server
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
# [*api_version*]
#   (optional) Version of nova API to use in novaclient.
#   Defaults to 2
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

class magnum::clients::nova(
  $region_name   = $magnum::clients::region_name,
  $endpoint_type = $magnum::clietns::endpoint_type,
  $api_version   = '2',
  $ca_file       = $magnum::clients::ca_file,
  $cert_file     = $magnum::clients::cert_file,
  $key_file      = $magnum::clients::key_file,
  $insecure      = $magnum::clients::insecure
){

  include ::magnum::deps
  include ::magnum::params

  magnum_config {
    'nova_client/region_name':   value => $region_name;
    'nova_client/endpoint_type': value => $endpoint_type;
    'nova_client/api_version':   value => $api_version;
    'nova_client/ca_file':       value => $ca_file;
    'nova_client/cert_file':     value => $cert_file;
    'nova_client/key_file':      value => $key_file;
    'nova_client/insecure':      value => $insecure;
  }
}
