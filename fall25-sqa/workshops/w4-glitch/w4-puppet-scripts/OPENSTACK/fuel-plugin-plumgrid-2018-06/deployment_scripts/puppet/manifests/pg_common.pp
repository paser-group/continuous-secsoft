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

notice('MODULAR: plumgrid/pre_node.pp')

$fuel_hash              = hiera_hash('public_ssl', {})
$fuel_hostname          = pick($fuel_hash['hostname'])

$metadata_hash          = hiera_hash('quantum_settings', {})
$metadata               = pick($metadata_hash['metadata']['metadata_proxy_shared_secret'], 'root')

$plumgrid_hash = hiera_hash('plumgrid', {})
$plumgrid_username      = pick($plumgrid_hash['plumgrid_username'])
$plumgrid_password      = pick($plumgrid_hash['plumgrid_password'])
$plumgrid_pkg_repo      = pick($plumgrid_hash['plumgrid_package_repo'])
$plumgrid_lic           = pick($plumgrid_hash['plumgrid_license'])
$plumgrid_vip           = pick($plumgrid_hash['plumgrid_virtual_ip'])
$plumgrid_zone          = pick($plumgrid_hash['plumgrid_zone'])
$fabric_network         = pick($plumgrid_hash['plumgrid_fabric_network'])
$opsvm_ip               = pick($plumgrid_hash['plumgrid_opsvm'])
$fuel_version           = hiera('fuel_version')

$network_metadata       = hiera_hash('network_metadata')
$haproxy_vip            = pick($network_metadata['vips']['public']['ipaddr'])
$controller_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
$controller_address_map = get_node_to_ipaddr_map_by_network_role($controller_nodes, 'mgmt/vip')
$controller_ipaddresses = join(hiera_array('controller_ipaddresses', values($controller_address_map)), ',')
$compute_nodes          = get_nodes_hash_by_roles($network_metadata, ['compute'])
$compute_address_map    = get_node_to_ipaddr_map_by_network_role($compute_nodes, 'mgmt/vip')
$compute_ipaddresses    = join(hiera_array('compute_ipaddresses', values($compute_address_map)), ',')
$gateway_nodes          = get_nodes_hash_by_roles($network_metadata, ['PLUMgrid-Gateway'])
$gateway_address_map    = get_node_to_ipaddr_map_by_network_role($gateway_nodes, 'mgmt/vip')
$gateway_ipaddresses    = join(hiera_array('gateway_ipaddresses', values($gateway_address_map)), ',')

$pg_packages = [ 'python-pip', 'apparmor-utils' ]

package { $pg_packages:
  ensure  => present,
  require => Exec['apt-get update']
}

exec { 'aa-disable':
  command   => 'aa-disable /sbin/dhclient',
  path      => ['/usr/sbin', '/bin/'],
  onlyif    => 'aa-status | grep /sbin/dhclient',
  subscribe => Package['apparmor-utils']
}

exec { "apt-get update":
  command => "/usr/bin/apt-get update"
}

file { '/tmp/plumgrid_config':
  ensure  => file,
  content => "fuel_hostname=$fuel_hostname\nplumgrid_username=$plumgrid_username\nplumgrid_password=$plumgrid_password\nhaproxy_vip=$haproxy_vip\ndirector_ip=$controller_ipaddresses\nedge_ip=$compute_ipaddresses\ngateway_ip=$gateway_ipaddresses\nmetadata_secret=$metadata\nvip=$plumgrid_vip\nopsvm_ip=$opsvm_ip\npg_repo=$plumgrid_pkg_repo\nzone_name=$plumgrid_zone\nfabric_network=$fabric_network\nfuel_version=$fuel_version\nlicense=$plumgrid_lic",
}

file { ['/var/lib/plumgrid', '/var/lib/plumgrid/zones', "/var/lib/plumgrid/zones/$plumgrid_zone"]:
  ensure  =>  directory,
  mode    =>  0755,
}->
exec { "lcm_key":
  command => "/usr/bin/curl -Lks http://$plumgrid_pkg_repo:81/files/ssh_keys/zones/$plumgrid_zone/id_rsa.pub -o /var/lib/plumgrid/zones/$plumgrid_zone/id_rsa.pub",
}

exec { "get_GPG":
  command => "/usr/bin/curl -Lks http://$plumgrid_pkg_repo:81/plumgrid/GPG-KEY -o /tmp/GPG-KEY",
}->
exec { "apt-key":
  path        => '/bin:/usr/bin',
  environment => 'HOME=/root',
  command     => 'apt-key add /tmp/GPG-KEY',
}
