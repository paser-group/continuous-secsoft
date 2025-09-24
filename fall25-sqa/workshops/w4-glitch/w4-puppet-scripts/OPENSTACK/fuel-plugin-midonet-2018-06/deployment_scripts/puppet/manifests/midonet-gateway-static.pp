
notice('MODULAR: midonet-gateway-static.pp')

$management_address = hiera('management_vip')
$access_data      = hiera_hash('access')
$username         = $access_data['user']
$password         = $access_data['password']
$tenant_name      = $access_data['tenant']

$midonet_settings = hiera_hash('midonet')
$floating_cidr    = $midonet_settings['floating_cidr']
$f_net_cidr       = split($midonet_settings['floating_cidr'], '/')

$nodes_hash = hiera('nodes')
$node       = filter_nodes($nodes_hash, 'fqdn', $::fqdn)
$gw_ip      = $node[0]['public_address']
$gw_mask    = $node[0]['public_netmask']
$net_hash   = public_network_hash($gw_ip, $gw_mask)

$static_linux_bridge_ip_netl     = $midonet_settings['static_linux_bridge_address']
$static_fake_edge_router_ip_netl = $midonet_settings['static_fake_edge_router_address']
$static_use_masquerade           = $midonet_settings['static_use_masquerade']

$static_linux_bridge_ip_address      = split($static_linux_bridge_ip_netl,'/')
$static_fake_edge_router_ip_address  = split($static_fake_edge_router_ip_netl,'/')

$slbip_without_netl = $static_linux_bridge_ip_address[0]

class { 'midonet::gateway::static':
  nic            => 'br-ex',
  fip            => $floating_cidr,
  edge_router    => 'edge-router',
  veth0_ip       => $static_linux_bridge_ip_address[0],
  veth1_ip       => $static_fake_edge_router_ip_address[0],
  veth_network   => generate_cidr_from_ip_netlength($static_linux_bridge_ip_netl),
  scripts_dir    => '/tmp',
  uplink_script  => 'create_fake_uplink_l2.sh',
  ensure_scripts => 'present',
  masquerade     => $static_use_masquerade? {true => 'on' ,default => 'off' }
}
contain ::midonet::gateway::static

file {'/etc/init/midonet-network-static.conf':
  ensure  => present,
  source  => '/etc/fuel/plugins/midonet-9.2/puppet/files/startup-static.conf',
  require => Exec['run gateway static creation script']
}
