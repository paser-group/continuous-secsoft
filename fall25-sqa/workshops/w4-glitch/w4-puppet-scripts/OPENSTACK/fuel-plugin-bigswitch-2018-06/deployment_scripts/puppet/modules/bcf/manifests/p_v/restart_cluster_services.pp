#
#    Copyright 2015 BigSwitch Networks, Inc.
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
#
class bcf::p_v::restart_cluster_services {

    include bcf
    include bcf::params
    $binpath = '/usr/local/bin/:/bin/:/usr/bin:/usr/sbin:/usr/local/sbin:/sbin'

    $nodes_hash = hiera('nodes', {})
    $roles = node_roles($nodes_hash, hiera('uid'))

    if member($roles, 'primary-controller') {
        exec { 'restart neutron-dhcp-agent':
            command => 'crm resource restart p_neutron-dhcp-agent',
            path    => '/usr/local/bin/:/bin/:/usr/sbin',
        } ->
        exec { 'restart neutron-metadata-agent':
            command => 'crm resource restart p_neutron-metadata-agent',
            path    => '/usr/local/bin/:/bin/:/usr/sbin',
        } ->
        exec { 'stop neutron-l3-agent':
            command => 'crm resource stop p_neutron-l3-agent',
            path    => '/usr/local/bin/:/bin/:/usr/sbin',
        } ->
        exec { 'clean up neutron-l3-agent':
            command => 'crm resource cleanup p_neutron-l3-agent',
            path    => '/usr/local/bin/:/bin/:/usr/sbin',
        } ->
        exec { 'disable neutron-l3-agent':
            command => 'crm configure delete p_neutron-l3-agent',
            path    => '/usr/local/bin/:/bin/:/usr/sbin',
        } ->
        exec { 'restart neutron-plugin-openvswitch-agent':
            command => 'crm resource restart p_neutron-plugin-openvswitch-agent',
            path    => '/usr/local/bin/:/bin/:/usr/sbin',
        }
    }
}
