# == Class: magnum::clients::cinder
#
# Manages cinder clients configuration in magnum server
#
# === Parameters:
#
# [*region_name*]
#   (optional) Region in Identity service catalog to use for communication
#   with the OpenStack service.
#   Defaults to RegionOne
#
class magnum::clients::cinder(
  $region_name   = $magnum::clients::region_name,
){

  include ::magnum::deps
  include ::magnum::params

  magnum_config {
    'cinder_client/region_name': value => $region_name;
  }
}
