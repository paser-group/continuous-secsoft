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
notice('MODULAR: midonet-install-cluster.pp')
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
$insights               = $midonet_settings['mem_insights']

$midonet_version        = $midonet_settings['midonet_version']

$nodes_hash      = hiera('nodes')
$node            = filter_nodes($nodes_hash, 'fqdn', $::fqdn)
$priv_ip         = $node[0]['internal_address']
$priv_netmask    = $node[0]['internal_netmask']
$pub_ip          = $node[0]['public_address']


include ::stdlib
class {'::midonet::cluster':
  is_mem               => $mem,
  zookeeper_hosts      => $zoo_ips_hash,
  cassandra_servers    => $cass_ips,
  cassandra_rep_factor => size($nsdb_hash),
  keystone_host        => $management_vip,
  keystone_admin_token => $keystone_data['admin_token'],
  keystone_tenant_name => $access_data['tenant'],
  keystone_protocol    => $admin_identity_protocol,
  cluster_port         => '8181',
  is_insights          => $insights,
  analytics_ip         => $ana_mgmt_ip,
  max_heap_size        => '2048M',
  heap_newsize         => '1024M',
  midonet_version      => $midonet_version,
  endpoint_host        => $priv_ip,
  endpoint_port        => '8999',
  elk_seeds            => join($ana_mgmt_ip_list,','),
  elk_target_endpoint  => generate_cidr_from_ip_netlength("${priv_ip} ${priv_netmask}"),
  jarvis_enabled       => false,
  state_proxy_address  => $priv_ip
}
# HA proxy configuration
Haproxy::Service        { use_include => true }
Haproxy::Balancermember { use_include => true }
Openstack::Ha::Haproxy_service {
  server_names        => keys($controllers_mgmt_ips),
  ipaddresses         => values($controllers_mgmt_ips),
  public_virtual_ip   => $public_vip,
  internal_virtual_ip => $management_vip,
}
openstack::ha::haproxy_service { 'midonetcluster':
  order                  => 199,
  listen_port            => 8181,
  balancermember_port    => 8181,
  define_backups         => true,
  before_start           => true,
  public                 => true,
  haproxy_config_options => {
    'balance' => 'roundrobin',
    'option'  => ['httplog'],
  },
  balancermember_options => 'check',
}
exec { 'haproxy reload':
  command   => 'export OCF_ROOT="/usr/lib/ocf"; (ip netns list | grep haproxy) && ip netns exec haproxy /usr/lib/ocf/resource.d/fuel/ns_haproxy reload',
  path      => '/usr/bin:/usr/sbin:/bin:/sbin',
  logoutput => true,
  provider  => 'shell',
  tries     => 10,
  try_sleep => 10,
  returns   => [0, ''],
}
Haproxy::Listen <||> -> Exec['haproxy reload']
Haproxy::Balancermember <||> -> Exec['haproxy reload']
class { 'firewall': }
firewall {'502 Midonet cluster':
  port   => '8181',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'503 Midonet cluster state proxy':
  port   => '2346',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'511 Midonet cluster unified endpoint':
  port   => '8999',
  proto  => 'tcp',
  action => 'accept',
}

firewall {'521 Midonet flow history':
  port   => '5001',
  proto  => 'tcp',
  action => 'accept',
}
