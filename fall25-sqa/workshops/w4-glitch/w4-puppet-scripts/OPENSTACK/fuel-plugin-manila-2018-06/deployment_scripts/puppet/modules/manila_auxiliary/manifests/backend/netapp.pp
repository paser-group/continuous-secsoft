define manila_auxiliary::backend::netapp (
  $share_driver                         = 'manila.share.drivers.netapp.common.NetAppDriver',
  $driver_handles_share_servers         = 'True',
  $netapp_storage_family                = 'ontap_cluster',
  $netapp_server_hostname               = undef,
  $netapp_server_port                   = '80',
  $netapp_login                         = undef,
  $netapp_password                      = undef,
  $netapp_transport_type                = 'https',
  $netapp_root_volume_aggregate         = 'aggr1',
  $netapp_aggregate_name_search_pattern = '^((?!aggr0).)*$',
  $netapp_port_name_search_pattern      = '^(e0a)$',
  ) {

  manila_config {
    "${name}/share_backend_name":                   value => $name;
    "${name}/share_driver":                         value => $share_driver;
    "${name}/driver_handles_share_servers":         value => $driver_handles_share_servers;
    "${name}/netapp_storage_family":                value => $netapp_storage_family;
    "${name}/netapp_server_hostname":               value => $netapp_server_hostname;
    "${name}/netapp_server_port":                   value => $netapp_server_port;
    "${name}/netapp_login":                         value => $netapp_login;
    "${name}/netapp_password":                      value => $netapp_password;
    "${name}/netapp_transport_type":                value => $netapp_transport_type;
    "${name}/netapp_root_volume_aggregate":         value => $netapp_root_volume_aggregate;
    "${name}/netapp_aggregate_name_search_pattern": value => $netapp_aggregate_name_search_pattern;
    "${name}/netapp_port_name_search_pattern":      value => $netapp_port_name_search_pattern;
    }~>Service['manila-share']
  }
