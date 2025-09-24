#
# Copyright (c) 2016, PLUMgrid Inc, http://plumgrid.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

notice('MODULAR: plumgrid/edge.pp')

# Metadata settings
$metadata_hash     = hiera_hash('quantum_settings', {})
$metadata_secret   = pick($metadata_hash['metadata']['metadata_proxy_shared_secret'], 'root')
$nova_hash         = hiera_hash('nova', {})
$nova_sql_password = pick($nova_hash['db_password'])
$mgmt_vip          = hiera('management_vip')

# PLUMgrid settings
$plumgrid_hash     = hiera_hash('plumgrid', {})
$plumgrid_pkg_repo = pick($plumgrid_hash['plumgrid_package_repo'])
$plumgrid_vip      = pick($plumgrid_hash['plumgrid_virtual_ip'])

# PLUMgrid Zone settings
$network_metadata       = hiera_hash('network_metadata')
$controller_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
$controller_address_map = get_node_to_ipaddr_map_by_network_role($controller_nodes, 'mgmt/vip')
$controller_ipaddresses = join(hiera_array('controller_ipaddresses', values($controller_address_map)), ',')
$mgmt_net               = hiera('management_network_range')
$fabric_dev             = 'br-100000' 
$plumgrid_zone          = pick($plumgrid_hash['plumgrid_zone'])
$md_ip                  = pick($plumgrid_hash['plumgrid_opsvm'])

class { 'plumgrid':
  plumgrid_ip => $controller_ipaddresses,
  mgmt_dev    => 'br-mgmt',
  fabric_dev  => $fabric_dev,
  lvm_keypath => "/var/lib/plumgrid/zones/$plumgrid_zone/id_rsa.pub",
  md_ip       => $md_ip,
  source_net  => $mgmt_net,
  dest_net    => $mgmt_net,
}->
exec { 'Setup plumgrid-sigmund service':
  command => "/opt/local/bin/nsenter -t \$(ps ho pid --ppid \$(cat /var/run/libvirt/lxc/plumgrid.pid)) -m -n -u -i -p /usr/bin/sigmund-configure --ip $md_ip --start --autoboot",
  returns => [0, 1],
}

package { 'nova-api':
  ensure => present,
  name   => 'nova-api',
}

package { 'nova-compute':
  ensure => present,
  name   => 'nova-compute',
}

file { '/etc/nova/nova.conf':
  ensure  => present,
  notify  => [ Service['nova-compute'], Service['nova-api'] ]
}

file_line { 'Set libvirt vif':
  path    => '/etc/nova/nova.conf',
  line    => 'libvirt_vif_type=ethernet',
  match   => '^libvirt_vif_type.*$',
  require => File['/etc/nova/nova.conf']
}

file_line { 'Set libvirt cpu mode':
  path    => '/etc/nova/nova.conf',
  line    => 'libvirt_cpu_mode=none',
  match   => '^libvirt_cpu_mode.*$',
  require => File['/etc/nova/nova.conf']
}

# Enabling Metadata on Computes
file_line { 'Enable Metadata Proxy':
  path    => '/etc/nova/nova.conf',
  line    => 'service_metadata_proxy=True',
  match   => '^#service_metadata_proxy=false',
  require => File['/etc/nova/nova.conf']
}

file_line { 'Set Metadata Shared Secret':
  path    => '/etc/nova/nova.conf',
  line    => "metadata_proxy_shared_secret=$metadata_secret",
  match   => '^#metadata_proxy_shared_secret=',
  require => File['/etc/nova/nova.conf']
}

file_line { 'Copy nova sql url on computes':
  path    => '/etc/nova/nova.conf',
  line    => "connection = mysql://nova:$nova_sql_password@$mgmt_vip/nova?read_timeout=60",
  after   => '^#connection = <None>',
  require => File['/etc/nova/nova.conf']
}

service { 'libvirt-bin':
  ensure => running,
  name   => 'libvirt-bin',
  enable => true,
}

service { 'nova-api':
  ensure  => running,
  name    => 'nova-api',
  require => Package['nova-api'],
  enable  => true,
}

service { 'nova-compute':
  ensure  => running,
  name    => 'nova-compute',
  require => Package['nova-compute'],
  enable  => true,
}

file { '/etc/libvirt/qemu.conf':
  ensure => present,
  notify => Service['libvirt-bin'],
}

file_line { 'Libvirt QEMU settings':
  path    => '/etc/libvirt/qemu.conf',
  line    => 'cgroup_device_acl = ["/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom", "/dev/ptmx", "/dev/kvm", "/dev/kqemu", "/dev/rtc", "/dev/hpet", "/dev/net/tun"]',
  require => File['/etc/libvirt/qemu.conf'],
}

# Enable packet forwarding for IPv4
exec { 'sysctl -w net.ipv4.ip_forward=1':
  command => '/sbin/sysctl -w net.ipv4.ip_forward=1'
}

file { '/etc/sysctl.conf':
  ensure => present
}

file_line { 'Enable IP4 packet forwarding':
  path    => '/etc/sysctl.conf',
  line    => 'net.ipv4.ip_forward=1',
  match   => '^#net.ipv4.ip_forward=1',
  require => File['/etc/sysctl.conf']
}

Package['nova-api'] -> File['/etc/nova/rootwrap.d/network.filters'] ~> Service['nova-compute']

file { '/etc/nova/rootwrap.d/network.filters':
  ensure => present,
  mode   => '0644',
  source => 'puppet:///modules/plumgrid/network.filters'
}

file_line { 'unmount plumgrid.fuse post-stop':
  path    => '/etc/init/plumgrid.conf',
  line    => '  umount --fake /run/libvirt/lxc/plumgrid.fuse',
  after   => 'virsh -c lxc: destroy plumgrid',
  require => Package[$plumgrid::params::plumgrid_package]
}

file_line { 'unmount plumgrid.fuse pre-start':
  path    => '/etc/init/plumgrid.conf',
  line    => '  umount --fake /run/libvirt/lxc/plumgrid.fuse',
  after   => '/opt/pg/scripts/systemd_pre_start.sh',
  require => Package[$plumgrid::params::plumgrid_package]
}

firewall { '990 Add iptables rule for metadata':
  chain  => 'INPUT',
  port   => '8775',
  proto  => 'tcp',
  action => 'accept',
}
