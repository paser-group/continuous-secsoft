notice('fuel-plugin-nsx-t: compute_vmware_nova_config.pp')

include ::nova::params

$neutron_config = hiera_hash('neutron_config')
$neutron_metadata_proxy_secret = $neutron_config['metadata']['metadata_proxy_shared_secret']

$management_vip            = hiera('management_vip')
$service_endpoint          = hiera('service_endpoint', $management_vip)
$ssl_hash                  = hiera_hash('use_ssl', {})
$neutron_username          = pick($neutron_config['keystone']['admin_user'], 'neutron')
$neutron_password          = $neutron_config['keystone']['admin_password']
$neutron_tenant_name       = pick($neutron_config['keystone']['admin_tenant'], 'services')
$region                    = hiera('region', 'RegionOne')
$admin_identity_protocol   = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'protocol', 'http')
$admin_identity_address    = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'hostname', [$service_endpoint, $management_vip])
$neutron_internal_protocol = get_ssl_property($ssl_hash, {}, 'neutron', 'internal', 'protocol', 'http')
$neutron_endpoint          = get_ssl_property($ssl_hash, {}, 'neutron', 'internal', 'hostname', [hiera('neutron_endpoint', ''), $management_vip])
$auth_api_version          = 'v3'
$admin_identity_uri        = "${admin_identity_protocol}://${admin_identity_address}:35357"
$neutron_auth_url          = "${admin_identity_uri}/${auth_api_version}"
$neutron_url               = "${neutron_internal_protocol}://${neutron_endpoint}:9696"

class {'nova::network::neutron':
  neutron_password     => $neutron_password,
  neutron_project_name => $neutron_tenant_name,
  neutron_region_name  => $region,
  neutron_username     => $neutron_username,
  neutron_auth_url     => $neutron_auth_url,
  neutron_url          => $neutron_url,
  neutron_ovs_bridge   => '',
}

nova_config {
  'neutron/service_metadata_proxy':       value => 'True';
  'neutron/metadata_proxy_shared_secret': value => $neutron_metadata_proxy_secret;
}

service { 'nova-compute':
  ensure     => running,
  name       => $::nova::params::compute_service_name,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
}

Class['nova::network::neutron'] ~> Service['nova-compute']
Nova_config<| |> ~> Service['nova-compute']
