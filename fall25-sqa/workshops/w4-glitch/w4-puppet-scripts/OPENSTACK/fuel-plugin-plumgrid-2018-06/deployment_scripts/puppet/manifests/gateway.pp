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

notice('MODULAR: plumgrid/gateway.pp')

# PLUMgrid settings
$plumgrid_hash          = hiera_hash('plumgrid', {})
$plumgrid_gw_devs       = pick($plumgrid_hash['gateway_devs'])

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
  plumgrid_ip  => $controller_ipaddresses,
  mgmt_dev     => 'br-mgmt',
  fabric_dev   => $fabric_dev,
  gateway_devs => split($plumgrid_gw_devs, ','),
  lvm_keypath  => "/var/lib/plumgrid/zones/$plumgrid_zone/id_rsa.pub",
  md_ip        => $md_ip,
  source_net   => $mgmt_net,
  dest_net     => $mgmt_net,
}->
exec { 'Setup plumgrid-sigmund service':
  command => "/opt/local/bin/nsenter -t \$(ps ho pid --ppid \$(cat /var/run/libvirt/lxc/plumgrid.pid)) -m -n -u -i -p /usr/bin/sigmund-configure --ip $md_ip --start --autoboot",
  returns => [0, 1],
}

package { 'iptables-persistent':
  ensure => present,
  name   => 'iptables-persistent'
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
