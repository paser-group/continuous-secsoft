
notice('MODULAR: midonet-cleanup-masquerade.pp')
include ::stdlib

$old_config = loadyamlv2('/etc/fuel/cluster/astute.yaml.old','notfound')

# If it's a redeploy and the file exists we can proceed
if($old_config != 'notfound')
{
  $old_gw_type = $old_config['midonet']['gateway_type']
  if ($old_gw_type == 'static') {

    # Extract data from hiera
    $access_data           = $old_config['access']
    $keystone_admin_tenant = $access_data['tenant']
    $net_metadata          = $old_config['network_metadata']
    $neutron_settings      = $old_config['quantum_settings']
    $external_net_name     = $neutron_settings['default_floating_net']
    $tenant_net_name       = $neutron_settings['default_private_net']
    $predefined_nets       = $neutron_settings['predefined_networks']
    $tenant_net            = $predefined_nets[$tenant_net_name]
    $external_net          = $predefined_nets[$external_net_name]

    $old_midonet_settings = $old_config['midonet']
    $old_net_metadata     = $old_config['network_metadata']
    $controllers_map      = get_nodes_hash_by_roles($old_net_metadata, ['controller', 'primary-controller'])


    $management_address = hiera('management_vip')
    $username         = $access_data['user']
    $password         = $access_data['password']
    $tenant_name      = $access_data['tenant']

    $midonet_settings = $old_config['midonet']
    $floating_cidr    = $midonet_settings['floating_cidr']
    $f_net_cidr       = split($midonet_settings['floating_cidr'], '/')

    $static_linux_bridge_ip_netl     = $midonet_settings['static_linux_bridge_address']
    $static_fake_edge_router_ip_netl = $midonet_settings['static_fake_edge_router_address']
    $static_use_masquerade           = $midonet_settings['static_use_masquerade']

    $static_linux_bridge_ip_address      = split($static_linux_bridge_ip_netl,'/')
    $static_fake_edge_router_ip_address  = split($static_fake_edge_router_ip_netl,'/')

    $slbip_without_netl = $static_linux_bridge_ip_address[0]

    $gw_hash               = get_nodes_hash_by_roles($net_metadata, ['midonet-gw'])
    $gw_mgmt_ip_hash       = get_node_to_ipaddr_map_by_network_role($gw_hash, 'management')
    $gw_mgmt_ip_list       = values($gw_mgmt_ip_hash)
    $gw_keys               = keys($gw_hash)

    $nic          = 'br-ex'
    $fip          = $old_midonet_settings['floating_cidr']

    file { 'delete masquerade script':
      ensure  => present,
      path    => '/tmp/remove_router_interfaces.sh',
      content => template('/etc/fuel/plugins/midonet-9.2/puppet/templates/cleanup_masquerade.sh.erb'),
    } ->

    # Finally, execute the script
    exec { 'run delete masquerade script':
      command => '/bin/bash -x /tmp/cleanup_masquerade.sh 2>&1 | tee /tmp/cleanup_masq.out',
      returns => ['0', '7'],
    }


  }
}
