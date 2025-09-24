notice('MODULAR: ironic/vips.pp')

$network_scheme    = hiera('network_scheme', {})
prepare_network_config($network_scheme)
$network_metadata  = hiera_hash('network_metadata', {})
$neutron_config    = hiera_hash('quantum_settings')
$pnets             = $neutron_config['L2']['phys_nets']
$baremetal_vip     = $network_metadata['vips']['baremetal']['ipaddr']
$baremetal_int     = get_network_role_property('ironic/baremetal', 'interface')
$baremetal_ipaddr  = get_network_role_property('ironic/baremetal', 'ipaddr')
$baremetal_netmask = get_network_role_property('ironic/baremetal', 'netmask')
$baremetal_network = get_network_role_property('ironic/baremetal', 'network')
$nameservers       = $neutron_config['predefined_networks']['net04']['L3']['nameservers']

$ironic_hash       = hiera_hash('fuel-plugin-ironic', {})
$baremetal_L3_allocation_pool = $ironic_hash['l3_allocation_pool']
$baremetal_L3_gateway = $ironic_hash['l3_gateway']


# Firewall
###############################
firewallchain { 'baremetal:filter:IPv4':
  ensure => present,
} ->
firewall { '100 allow ping from VIP':
  chain       => 'baremetal',
  source      => $baremetal_vip,
  destination => $baremetal_ipaddr,
  proto       => 'icmp',
  icmp        => 'echo-request',
  action      => 'accept',
} ->
firewall { '999 drop all':
  chain  => 'baremetal',
  action => 'drop',
  proto  => 'all',
} ->
firewall {'00 baremetal-filter ':
  proto   => 'all',
  iniface => $baremetal_int,
  jump => 'baremetal',
  require => Class['openstack::firewall'],
}

class { 'openstack::firewall':}


# VIP
###############################
$ns_iptables_start_rules = "iptables -A INPUT -i baremetal-ns -s ${baremetal_network} -d ${baremetal_vip} -p tcp -m multiport --dports 6385,8080 -m state --state NEW -j ACCEPT; iptables -A INPUT -i baremetal-ns -s ${baremetal_network} -d ${baremetal_vip} -m state --state ESTABLISHED,RELATED -j ACCEPT; iptables -A INPUT -i baremetal-ns -j DROP"
$ns_iptables_stop_rules = "iptables -D INPUT -i baremetal-ns -s ${baremetal_network} -d ${baremetal_vip} -p tcp -m multiport --dports 6385,8080 -m state --state NEW -j ACCEPT; iptables -D INPUT -i baremetal-ns -s ${baremetal_network} -d ${baremetal_vip} -m state --state ESTABLISHED,RELATED -j ACCEPT; iptables -D INPUT -i baremetal-ns -j DROP"
$baremetal_vip_data = {
  namespace      => 'haproxy',
  nic            => $baremetal_int,
  base_veth      => 'baremetal-base',
  ns_veth        => 'baremetal-ns',
  ip             => $baremetal_vip,
  cidr_netmask   => netmask_to_cidr($baremetal_netmask),
  gateway        => 'none',
  gateway_metric => '0',
  bridge         => $baremetal_int,
  ns_iptables_start_rules => $ns_iptables_start_rules,
  ns_iptables_stop_rules  => $ns_iptables_stop_rules,
  iptables_comment        => 'baremetal-filter',
}

cluster::virtual_ip { 'baremetal' :
  vip => $baremetal_vip_data,
}


# Order
###############################
Firewall<||> -> Cluster::Virtual_ip<||>
