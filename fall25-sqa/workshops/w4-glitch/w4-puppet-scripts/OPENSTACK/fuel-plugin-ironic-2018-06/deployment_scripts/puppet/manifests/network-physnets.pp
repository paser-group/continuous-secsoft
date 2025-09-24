notice('MODULAR: ironic/network-physnets.pp')

$network_scheme    = hiera('network_scheme', {})
prepare_network_config($network_scheme)
$neutron_config    = hiera_hash('quantum_settings')
$pnets             = $neutron_config['L2']['phys_nets']
$baremetal_network = get_network_role_property('ironic/baremetal', 'network')
$nameservers       = $neutron_config['predefined_networks']['net04']['L3']['nameservers']

$ironic_hash       = hiera_hash('fuel-plugin-ironic', {})
$baremetal_L3_allocation_pool = $ironic_hash['l3_allocation_pool']
$baremetal_L3_gateway = $ironic_hash['l3_gateway']

# Physnets
###############################
if $pnets['physnet1'] {
  $physnet1 = "physnet1:${pnets['physnet1']['bridge']}"
}
if $pnets['physnet2'] {
  $physnet2 = "physnet2:${pnets['physnet2']['bridge']}"
}
$physnet_ironic = "physnet-ironic:br-ironic"
$physnets_array = [$physnet1, $physnet2, $physnet_ironic]
$bridge_mappings = delete_undef_values($physnets_array)

$br_map_str = join($bridge_mappings, ',')
neutron_agent_ovs {
  'ovs/bridge_mappings': value => $br_map_str;
}

$flat_networks  = ['physnet-ironic']
neutron_plugin_ml2 {
  'ml2_type_flat/flat_networks': value => join($flat_networks, ',');
}

service { 'p_neutron-plugin-openvswitch-agent':
  ensure => 'running',
  enable => true,
  provider => 'pacemaker',
}
service { 'p_neutron-dhcp-agent':
  ensure => 'running',
  enable => true,
  provider => 'pacemaker',
}

Neutron_plugin_ml2<||> ~> Service['p_neutron-plugin-openvswitch-agent'] ~> Service['p_neutron-dhcp-agent']
Neutron_agent_ovs<||> ~> Service['p_neutron-plugin-openvswitch-agent'] ~> Service['p_neutron-dhcp-agent']

