notice('MODULAR: ironic/network-ovs.pp')

$network_scheme    = hiera('network_scheme', {})
prepare_network_config($network_scheme)
$baremetal_int     = get_network_role_property('ironic/baremetal', 'interface')
$sdn               = generate_network_config()

# OVS patch
###############################
class { 'l23network':
 use_ovs => true,
} ->
l23network::l2::bridge { 'br-ironic':
  provider => 'ovs'
} ->
l23network::l2::patch { "patch__${baremetal_int}--br-ironic":
  bridges => ['br-ironic', $baremetal_int],
  provider => 'ovs',
  mtu => 65000,
}

