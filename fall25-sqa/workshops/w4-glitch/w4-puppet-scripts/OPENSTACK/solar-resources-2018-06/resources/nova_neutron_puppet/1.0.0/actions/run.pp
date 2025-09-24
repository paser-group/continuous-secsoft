$resource = hiera($::resource_name)

$auth_host                 = $resource['input']['auth_host']
$auth_port                 = $resource['input']['auth_port']
$auth_protocol             = $resource['input']['auth_protocol']
$neutron_endpoint_host     = $resource['input']['neutron_endpoint_host']
$neutron_endpoint_port     = $resource['input']['neutron_endpoint_port']
$neutron_endpoint_protocol = $resource['input']['neutron_endpoint_protocol']

$libvirt_vif_driver               = $resource['input']['libvirt_vif_driver']
$force_snat_range                 = $resource['input']['force_snat_range']
$neutron_admin_password           = $resource['input']['neutron_admin_password']
$neutron_auth_strategy            = $resource['input']['neutron_auth_strategy']
$neutron_url_timeout              = $resource['input']['neutron_url_timeout']
$neutron_admin_tenant_name        = $resource['input']['neutron_admin_tenant_name']
$neutron_default_tenant_id        = $resource['input']['neutron_default_tenant_id']
$neutron_region_name              = $resource['input']['neutron_region_name']
$neutron_admin_username           = $resource['input']['neutron_admin_username']
$neutron_ovs_bridge               = $resource['input']['neutron_ovs_bridge']
$neutron_extension_sync_interval  = $resource['input']['neutron_extension_sync_interval']
$neutron_ca_certificates_file     = $resource['input']['neutron_ca_certificates_file']
$network_api_class                = $resource['input']['network_api_class']
$security_group_api               = $resource['input']['security_group_api']
$firewall_driver                  = $resource['input']['firewall_driver']
$vif_plugging_is_fatal            = $resource['input']['vif_plugging_is_fatal']
$vif_plugging_timeout             = $resource['input']['vif_plugging_timeout']
$dhcp_domain                      = $resource['input']['dhcp_domain']


class { 'nova::compute::neutron':
  libvirt_vif_driver               => $libvirt_vif_driver,
  force_snat_range                 => $force_snat_range,
}

class { 'nova::network::neutron':
  neutron_admin_password           => $neutron_admin_password,
  neutron_auth_strategy            => $neutron_auth_strategy,
  neutron_url                      => "${neutron_endpoint_protocol}://${neutron_endpoint_host}:${neutron_endpoint_port}",
  neutron_url_timeout              => $neutron_url_timeout,
  neutron_admin_tenant_name        => $neutron_admin_tenant_name,
  neutron_default_tenant_id        => $neutron_default_tenant_id,
  neutron_region_name              => $neutron_region_name,
  neutron_admin_username           => $neutron_admin_username,
  neutron_admin_auth_url           => "${auth_protocol}://${auth_host}:${auth_port}/v2.0",
  neutron_ovs_bridge               => $neutron_ovs_bridge,
  neutron_extension_sync_interval  => $neutron_extension_sync_interval,
  neutron_ca_certificates_file     => $neutron_ca_certificates_file,
  network_api_class                => $network_api_class,
  security_group_api               => $security_group_api,
  firewall_driver                  => $firewall_driver,
  vif_plugging_is_fatal            => $vif_plugging_is_fatal,
  vif_plugging_timeout             => $vif_plugging_timeout,
  dhcp_domain                      => $dhcp_domain,
}
