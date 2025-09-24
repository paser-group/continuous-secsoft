notice('MODULAR: midonet-bgp-interfaces.pp')


exec {'add veth interface':
  path    => '/usr/bin:/usr/sbin:/sbin',
  command => 'ip link add gw-veth-br type veth peer name gw-veth-mn',
  unless  => 'ip l | /bin/grep gw-veth-br'
} ->

exec {'set gw-veth-br interface up':
  path    => '/usr/bin:/usr/sbin:/sbin',
  command => 'ip l set dev gw-veth-br up'
} ->

exec {'set gw-veth-mn interface up':
  path    => '/usr/bin:/usr/sbin:/sbin',
  command => 'ip l set dev gw-veth-mn up'
} ->

exec {'add veth to bridge':
  path    => '/usr/bin:/usr/sbin:/sbin',
  command => 'brctl addif br-ex gw-veth-br',
  unless  => 'brctl show br-ex | /bin/grep gw-veth-br'
} ->

file {'/etc/sysconfig/network-scripts/ifcfg-p_br-floating-0':
  ensure  => absent,
} ->

exec {'set up external bridge':
  path    => '/usr/bin:/usr/sbin:/sbin',
  command => 'ip link set dev br-ex up'
} ->

file {'/etc/init/midonet-network.conf':
  ensure => present,
  source => '/etc/fuel/plugins/midonet-9.2/puppet/files/startup.conf'
}
