notice('MODULAR: ironic/baremetal-firewall.pp')

$network_scheme    = hiera('network_scheme', {})
prepare_network_config($network_scheme)
$baremetal_int     = get_network_role_property('ironic/baremetal', 'interface')
$nodes_hash        = hiera('nodes', {})
$roles             = node_roles($nodes_hash, hiera('uid'))

if ! member($roles, 'controller') or ! member($roles, 'primary-controller') or ! member($roles, 'ironic') {
  firewallchain { 'baremetal:filter:IPv4':
    ensure => present,
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
}
