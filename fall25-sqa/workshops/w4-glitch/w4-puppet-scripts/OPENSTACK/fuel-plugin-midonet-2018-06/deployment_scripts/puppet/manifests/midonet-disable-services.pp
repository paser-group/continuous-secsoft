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
notice('MODULAR: midonet-disable-services.pp')
include ::stdlib

# Extract hiera data
$net_metadata = hiera_hash('network_metadata')

$node  = get_node_by_fqdn($net_metadata, $::fqdn)

$roles = $node['node_roles']

$ovs_agent_name = $operatingsystem ? {
  'CentOS' => 'neutron-openvswitch-agent',
  'Ubuntu' => 'neutron-plugin-openvswitch-agent',
}

$l3_agent_name = $operatingsystem ? {
  'CentOS' => 'neutron-l3-agent',
  'Ubuntu' => 'neutron-l3-agent'
}

$dhcp_agent_name = $operatingsystem ? {
  'CentOS' => 'neutron-dhcp-agent',
  'Ubuntu' => 'neutron-dhcp-agent'
}

$metadata_agent_name = $operatingsystem ? {
  'CentOS' => 'neutron-metadata-agent',
  'Ubuntu' => 'neutron-metadata-agent'
}

if member($roles, 'primary-controller') {

  exec {'stop-dhcp-agent':
    command => 'crm resource stop clone_neutron-dhcp-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status clone_neutron-dhcp-agent'
  } ->
  exec {'stop-metadata-agent':
    command => 'crm resource stop clone_neutron-metadata-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status clone_neutron-metadata-agent'
  } ->
  exec {'delete-metadata-agent':
    command => 'crm configure delete clone_neutron-metadata-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status clone_neutron-metadata-agent'
  }->
  exec {'delete-dhcp-agent':
    command => 'crm configure delete clone_neutron-dhcp-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status clone_neutron-dhcp-agent'
  }->
  exec {'stop-dhcp-agent-N':
    command => 'crm resource stop neutron-dhcp-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status neutron-dhcp-agent'
  } ->
  exec {'stop-metadata-agent-N':
    command => 'crm resource stop neutron-metadata-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status neutron-metadata-agent'
  } ->
  exec {'delete-metadata-agent-N':
    command => 'crm configure delete neutron-metadata-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status neutron-metadata-agent'
  }->
  exec {'delete-dhcp-agent-N':
    command => 'crm configure delete neutron-dhcp-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status neutron-dhcp-agent'
  }->
  exec {'stop-l3-agent':
    command => 'crm resource stop p_neutron-l3-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status p_neutron-l3-agent'
  } ->
  exec {'delete-l3-agent':
    command => 'crm configure delete p_neutron-l3-agent',
    path    => '/usr/bin:/usr/sbin',
    onlyif  => 'crm resource status p_neutron-l3-agent'
  }->
  service {$dhcp_agent_name:
    ensure => stopped,
    enable => false
  }->

  service {$metadata_agent_name:
    ensure => stopped,
    enable => false
  }
} else {

  service {$dhcp_agent_name:
    ensure => stopped,
    enable => false
  }

  service {$metadata_agent_name:
    ensure => stopped,
    enable => false
  }
}
