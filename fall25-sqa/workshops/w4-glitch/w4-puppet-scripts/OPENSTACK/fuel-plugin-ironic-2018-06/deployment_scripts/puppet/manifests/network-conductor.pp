notice('MODULAR: ironic/network-conductor.pp')

$network_scheme    = hiera('network_scheme', {})
prepare_network_config($network_scheme)
$baremetal_int     = get_network_role_property('ironic/baremetal', 'interface')
$baremetal_ipaddr  = get_network_role_property('ironic/baremetal', 'ipaddr')
$baremetal_network = get_network_role_property('ironic/baremetal', 'network')

# Firewall
###############################
firewallchain { 'baremetal:filter:IPv4':
  ensure => present,
} ->
firewall { '100 allow rsyslog':
  chain  => 'baremetal',
  source => $baremetal_network,
  destination => $baremetal_ipaddr,
  proto  => 'udp',
  dport => '514',
  action => 'accept',
} ->
firewall { '101 allow TFTP':
  chain  => 'baremetal',
  source => $baremetal_network,
  destination => $baremetal_ipaddr,
  proto  => 'udp',
  dport => '69',
  action => 'accept',
} ->
firewall { '900 allow related':
  chain  => 'baremetal',
  source => $baremetal_network,
  destination => $baremetal_ipaddr,
  proto  => 'all',
  state => ['RELATED', 'ESTABLISHED'],
  action => 'accept',
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

exec { 'fix_ipt_modules':
  command => '/bin/sed -i "s/^IPT_MODULES=.*/IPT_MODULES=\"nf_conntrack_ftp nf_nat_ftp nf_conntrack_netbios_ns nf_conntrack_tftp\"/g" /etc/default/ufw',
  unless => '/bin/grep "^IPT_MODULES=.*nf_conntrack_tftp" /etc/default/ufw > /dev/null',
  notify => Exec['load_tftp_mod']
}

exec { 'load_tftp_mod':
  command => '/sbin/modprobe nf_conntrack_tftp',
  refreshonly => true,
}

class { 'openstack::firewall':}

