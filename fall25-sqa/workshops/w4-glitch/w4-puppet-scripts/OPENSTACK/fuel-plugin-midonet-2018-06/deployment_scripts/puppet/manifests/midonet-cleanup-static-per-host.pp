
notice('MODULAR: midonet-cleanup-static-per-host.pp')

  exec {'drop the veth pair':
    path    => '/usr/bin:/usr/sbin:/sbin',
    command => 'ip link delete veth0',
    onlyif  => 'ip l | /bin/grep -e veth0 -e veth1'
  } ->

  exec {'shut off the uplinkbridge':
    path    => '/usr/bin:/usr/sbin:/sbin',
    command => 'ifconfig uplinkbridge down',
    onlyif  => 'ip l | /bin/grep -e uplinkbridge'
  } ->

  exec {'delete the uplinkbridge':
    path    => '/usr/bin:/usr/sbin:/sbin',
    command => 'brctl delbr uplinkbridge',
    onlyif  => 'ip l | /bin/grep -e uplinkbridge'
  } ->

  file {'/etc/init/midonet-network-static.conf':
    ensure  => absent,
  }
