notice('fuel-plugin-nsx-t: install-nsx-packages.pp')

$nsx_required_packages = ['libunwind8', 'zip', 'libgflags2', 'libgoogle-perftools4', 'traceroute',
                          'python-mako', 'python-simplejson', 'python-support', 'python-unittest2',
                          'python-yaml', 'python-netaddr', 'libprotobuf8',
                          'libboost-filesystem1.54.0', 'dkms', 'libboost-chrono-dev',
                          'libboost-iostreams1.54.0', 'libvirt0']

$nsx_packages = ['libgoogle-glog0', 'libjson-spirit', 'nicira-ovs-hypervisor-node', 'nsxa',
                'nsx-agent', 'nsx-aggservice', 'nsx-cli', 'nsx-da', 'nsx-host',
                'nsx-host-node-status-reporter', 'nsx-lldp', 'nsx-logical-exporter', 'nsx-mpa',
                'nsx-netcpa', 'nsx-sfhc', 'nsx-transport-node-status-reporter',
                'openvswitch-common', 'openvswitch-datapath-dkms', 'openvswitch-pki',
                'openvswitch-switch', 'python-openvswitch', 'tcpdump-ovs']

package { $nsx_required_packages:
  ensure => latest,
}
package { $nsx_packages:
  ensure  => latest,
  require => [Package[$nsx_required_packages],Service['openvswitch-switch']]
}
service { 'openvswitch-switch':
  ensure => stopped,
  enable => false,
}
# This not shell(ubuntu dash) script, this bash script.
# if you leave it there all the command like '/bin/sh -c' cannot be executed
# example: start galera via pacemaker
file { '/etc/profile.d/nsx-alias.sh':
  ensure  => absent,
  require => Package[$nsx_packages],
}
