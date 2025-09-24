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
notice('MODULAR: midonet-install-agent.pp')

# Extract data from hiera
$midonet_settings  = hiera('midonet')
$net_metadata      = hiera_hash('network_metadata')
$neutron_config    = hiera_hash('quantum_settings')
$segmentation_type = $neutron_config['L2']['segmentation_type']
$nsdb_hash         = get_nodes_hash_by_roles($net_metadata, ['nsdb'])
$nsdb_mgmt_ips     = get_node_to_ipaddr_map_by_network_role($nsdb_hash, 'management')
$zoo_ips_hash      = generate_api_zookeeper_ips(values($nsdb_mgmt_ips))
$api_ip            = hiera('management_vip')
$access_data       = hiera_hash('access')
$username          = $access_data['user']
$password          = $access_data['password']
$tenant_name       = $access_data['tenant']
$mem               = $midonet_settings['mem']
$mem_user          = $midonet_settings['mem_repo_user']
$mem_password      = $midonet_settings['mem_repo_password']
$metadata_hash     = hiera_hash('quantum_settings', {})
$metadata_secret   = pick($metadata_hash['metadata']['metadata_proxy_shared_secret'], 'root')


$ovsdb_service_name = $operatingsystem ? {
  'CentOS' => 'openvswitch',
  'Ubuntu' => 'openvswitch-switch'
}

$openvswitch_package_neutron = $operatingsystem ? {
  'CentOS' => 'openstack-neutron-openvswitch',
  'Ubuntu' => 'neutron-plugin-openvswitch-agent'
}

$openvswitch_package = $operatingsystem ? {
  'CentOS' => 'openvswitch',
  'Ubuntu' => 'openvswitch-switch'
}

package {$openvswitch_package_neutron:
  ensure => purged
} ->

package {$openvswitch_package:
  ensure => purged
} ->

class {'::midonet::agent':
  zookeeper_hosts => $zoo_ips_hash,
  is_mem          => $mem,
  mem_username    => $mem_user,
  mem_password    => $mem_password,
  metadata_port   => '8775',
  shared_secret   => $metadata_secret,
  controller_host => $api_ip
} ->

class {'::midonet::cli':
  api_endpoint => "http://${api_ip}:8181/midonet-api",
  username     => $username,
  password     => $password,
  tenant_name  => $tenant_name,
}

# Firewall rule to allow the udp port used for vxlan tunnelling of overlay
#  traffic from midolman hosts to other midolman hosts.

class { 'firewall': }

if $segmentation_type =='tun' {
  firewall {'6677 vxlan port':
    port   => '6677',
    proto  => 'udp',
    action => 'accept',
  }
}

exec {'/usr/bin/mm-dpctl --delete-dp ovs-system':
  path    => '/usr/bin:/usr/sbin:/bin',
  onlyif  => '/usr/bin/mm-dpctl --show-dp ovs-system',
  require => Class['::midonet::agent']
}
