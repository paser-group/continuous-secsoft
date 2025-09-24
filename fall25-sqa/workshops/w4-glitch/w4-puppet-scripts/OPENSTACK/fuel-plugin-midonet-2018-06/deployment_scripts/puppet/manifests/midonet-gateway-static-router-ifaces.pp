
notice('MODULAR: midonet-gateway-static-router-ifaces.pp')

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

$net_metadata          = hiera_hash('network_metadata')

$gw_hash               = get_nodes_hash_by_roles($net_metadata, ['midonet-gw'])
$gw_keys               = keys($gw_hash)

$gw_fqdn = $gw_hash[$gw_keys[0]]['fqdn']

$ports_to_bind = "port-static-${gw_fqdn}"

$edge_router = 'edge-router'

$myhostname = $::fqdn

package { 'python-neutronclient':
  ensure => latest
} ->

file { 'create router interfaces script':
  ensure  => present,
  path    => '/tmp/create_router_interfaces_static.sh',
  content => template('/etc/fuel/plugins/midonet-9.2/puppet/templates/create_router_interfaces_static.sh.erb'),
} ->

# Finally, execute the script
exec { 'run create router interfaces script':
  command => '/bin/bash -x /tmp/create_router_interfaces_static.sh 2>&1 | tee /tmp/ri-create.out',
  returns => ['0', '7'],
}
