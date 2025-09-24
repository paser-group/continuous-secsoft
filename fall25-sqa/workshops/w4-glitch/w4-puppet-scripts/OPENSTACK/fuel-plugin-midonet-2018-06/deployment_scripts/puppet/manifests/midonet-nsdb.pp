#    Copyright 2015 Midokura SARL.
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
notice('MODULAR: midonet-nsdb.pp')

# Extract data from hiera
$fuel_settings    = parseyaml($astute_settings_yaml)
$net_metadata     = hiera_hash('network_metadata')
$nsdb_map         = get_nodes_hash_by_roles($net_metadata, ['nsdb'])
$zoo_hash         = generate_zookeeper_hash($nsdb_map)
$nsdb_mgmt_map    = get_node_to_ipaddr_map_by_network_role($nsdb_map, 'management')

class { '::midonet_openstack::profile::midojava::midojava':}
contain '::midonet_openstack::profile::midojava::midojava'

class { '::midonet_openstack::profile::zookeeper::midozookeeper':
  zk_servers => $zoo_hash['servers'],
  id         => $zoo_hash["${::fqdn}"]['id'],
  client_ip  => $zoo_hash["${::fqdn}"]['host'],
  require    => File['/usr/java/default']
}

class {'::midonet_openstack::profile::cassandra::midocassandra':
  seeds        => join(values($nsdb_mgmt_map),','),
  seed_address => $zoo_hash["${::fqdn}"]['host'],
  require      => File['/usr/java/default']
}

class { 'firewall': }

firewall {'500 zookeeper ports':
  port    => '2888-3888',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::zookeeper']
}

firewall {'501 zookeeper ports':
  port    => '2181',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::zookeeper']
}

firewall {'550 cassandra ports':
  port    => '9042',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::cassandra']
}

firewall {'551 cassandra ports':
  port    => '7000',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::cassandra']
}

firewall {'552 cassandra ports':
  port    => '7199',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::cassandra']
}

firewall {'553 cassandra ports':
  port    => '9160',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::cassandra']
}

firewall {'554 cassandra ports':
  port    => '59471',
  proto   => 'tcp',
  action  => 'accept',
  require => Class['::cassandra']
}
