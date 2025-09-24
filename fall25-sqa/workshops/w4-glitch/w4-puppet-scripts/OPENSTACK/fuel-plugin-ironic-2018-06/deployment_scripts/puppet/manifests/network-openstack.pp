notice('MODULAR: ironic/network-openstack.pp')

$network_scheme    = hiera('network_scheme', {})
prepare_network_config($network_scheme)
$neutron_config    = hiera_hash('quantum_settings')
$pnets             = $neutron_config['L2']['phys_nets']
$baremetal_network = get_network_role_property('ironic/baremetal', 'network')
$nameservers       = $neutron_config['predefined_networks']['net04']['L3']['nameservers']

$ironic_hash       = hiera_hash('fuel-plugin-ironic', {})
$baremetal_L3_allocation_pool = $ironic_hash['l3_allocation_pool']
$baremetal_L3_gateway = $ironic_hash['l3_gateway']


# Predefined network
###############################
$netdata = {
  'L2' => {
    network_type => 'flat',
    physnet => 'physnet-ironic',
    router_ext => 'false',
    segment_id => 'null'
  },
  'L3' => {
    enable_dhcp => true,
    floating => $baremetal_L3_allocation_pool,
    gateway => $baremetal_L3_gateway,
    nameservers => $nameservers,
    subnet => $baremetal_network
  },
  'shared' => 'true',
  'tenant' => 'admin',
}

openstack::network::create_network{'baremetal':
  netdata           => $netdata,
  segmentation_type => 'flat',
} ->
neutron_router_interface { "router04:baremetal__subnet":
  ensure => present,
}

