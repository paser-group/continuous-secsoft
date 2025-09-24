# == Class: magnum::clients::barbican
#
# Manages barbican clients configuration in magnum server
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

class magnum::clients::barbican(
  $region_name   = $magnum::clients::region_name,
  $endpoint_type = $magnum::clietns::endpoint_type,
){

  include ::magnum::deps
  include ::magnum::params

  magnum_config {
    'barbican_client/region_name':   value => $region_name;
    'barbican_client/endpoint_type': value => $endpoint_type;
  }
}
