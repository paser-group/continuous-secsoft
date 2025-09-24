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

notice('MODULAR: plumgrid/tools.pp')

# PLUMgrid settings
$metadata_hash          = hiera_hash('quantum_settings', {})
$metadata               = pick($metadata_hash['metadata']['metadata_proxy_shared_secret'], 'root')
$plumgrid_hash          = hiera_hash('plumgrid', {})
$plumgrid_pkg_repo      = pick($plumgrid_hash['plumgrid_package_repo'])
$plumgrid_vip           = pick($plumgrid_hash['plumgrid_virtual_ip'])
$plumgrid_gw_devs       = pick($plumgrid_hash['gateway_devs'])
$plumgrid_zone          = pick($plumgrid_hash['plumgrid_zone'])
$fabric_network         = pick($plumgrid_hash['plumgrid_fabric_network'])

# PLUMgrid Zone settings
$network_metadata       = hiera_hash('network_metadata')
$controller_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
$controller_address_map = get_node_to_ipaddr_map_by_network_role($controller_nodes, 'mgmt/vip')
$controller_ipaddresses = join(hiera_array('controller_ipaddresses', values($controller_address_map)), ' ')

$compute_nodes          = get_nodes_hash_by_roles($network_metadata, ['compute'])
$compute_address_map    = get_node_to_ipaddr_map_by_network_role($compute_nodes, 'mgmt/vip')
$compute_ipaddresses    = join(hiera_array('compute_ipaddresses', values($compute_address_map)), ' ')

$gateway_nodes          = get_nodes_hash_by_roles($network_metadata, ['PLUMgrid-Gateway'])
$gateway_address_map    = get_node_to_ipaddr_map_by_network_role($gateway_nodes, 'mgmt/vip')
$gateway_ipaddresses    = join(hiera_array('gateway_ipaddresses', values($gateway_address_map)), ' ')

file { '/etc/plumgrid':
  ensure  =>  directory,
  mode    =>  0755,
}

file { '/etc/plumgrid/plumgrid.conf':
  ensure  => file,
  mode    =>  0755,
  content => "zone_name=\"$plumgrid_zone\"\npg_director_ips=\"$controller_ipaddresses\"\npg_virt_ip=\"$plumgrid_vip\"\nplumgrid_repo_url=\"$plumgrid_pkg_repo\"\ncontrollers=\"$controller_ipaddresses\"\ncomputes=\"$compute_ipaddresses\"\nfabric_net=\"$fabric_network\"\nadd_gateway=\"yes\"\ngateway_devs=\"$plumgrid_gw_devs\"\ngateway_ips=\"$gateway_ipaddresses\""
}
