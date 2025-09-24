#    Copyright 2016 Midokura, SARL.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
notice('MODULAR: midonet-install-analytics.pp')
include ::stdlib

# Extract data from hiera
$ssl_hash                   = hiera_hash('use_ssl', {})

$midonet_settings           = hiera('midonet')
$net_metadata               = hiera_hash('network_metadata')
$controllers_map            = get_nodes_hash_by_roles($net_metadata, ['controller', 'primary-controller'])
$controllers_mgmt_ips       = get_node_to_ipaddr_map_by_network_role($controllers_map, 'management')
$nsdb_hash                  = get_nodes_hash_by_roles($net_metadata, ['nsdb'])
$nsdb_mgmt_ips              = get_node_to_ipaddr_map_by_network_role($nsdb_hash, 'management')
$zoo_ips_hash               = generate_api_zookeeper_ips(values($nsdb_mgmt_ips))
$management_vip             = hiera('management_vip')
$public_vip                 = hiera('public_vip')
$keystone_data              = hiera_hash('keystone')
$access_data                = hiera_hash('access')
$public_ssl_hash            = hiera('public_ssl')
$cass_ips                   = values($nsdb_mgmt_ips)
$mem                        = $midonet_settings['mem']
$admin_identity_protocol    = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'protocol', 'http')
$metadata_hash              = hiera_hash('quantum_settings', {})
$metadata_secret            = pick($metadata_hash['metadata']['metadata_proxy_shared_secret'], 'root')

$ana_hash               = get_nodes_hash_by_roles($net_metadata, ['midonet-analytics'])
$ana_mgmt_ip_hash       = get_node_to_ipaddr_map_by_network_role($ana_hash, 'management')
$ana_mgmt_ip_list       = values($ana_mgmt_ip_hash)
$ana_keys               = keys($ana_hash)

$ana_mgmt_ip            = empty($ana_keys)? {true => $public_vip , default => $ana_mgmt_ip_list[0] }

$midonet_version        = $midonet_settings['midonet_version']

$nodes_hash      = hiera('nodes')
$node            = filter_nodes($nodes_hash, 'fqdn', $::fqdn)
$priv_ip         = $node[0]['internal_address']
$priv_netmask    = $node[0]['internal_netmask']
$pub_ip          = $node[0]['public_address']
#Add MEM analytics class
class {'midonet::analytics':
  zookeeper_hosts => $zoo_ips_hash,
  is_mem          => true,
  manage_repo     => false,
  heap_size_gb    => '3',
  midonet_version => $midonet_version,
  elk_bind_ip     => $priv_ip,
  elk_hosts       => $ana_mgmt_ip_list
}

class { 'firewall': }

firewall {'507 Midonet elk 1':
  port   => '9200',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'508 Midonet clio':
  port   => '5000',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'509 Midonet flow history':
  port   => '5001',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'520 Midonet elk 2':
  port   => '9300',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'520 Midonet elk 3':
  port   => '5005',
  proto  => 'tcp',
  action => 'accept',
}
