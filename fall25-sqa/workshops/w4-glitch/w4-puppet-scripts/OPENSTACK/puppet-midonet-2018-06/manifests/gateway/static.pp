# == Class: midonet::gateway::static
#
# Set up a fake uplink with static routing on a gateway node
#
# === Parameters
#
# [*network_id*]
#   (Mandatory) Name of the bridge that will be created through midonet-cli
#
# [*cidr*]
#   (Mandatory) Network that will be assigned to the fake uplink
#
# [*gateway_ip*]
#   (Mandatory) Gateway IP through which the packets will go
#
# [*service_host*]
#   (Mandatory) Host where the Midonet API runs
#
# [*service_dir*]
#   (Mandatory) Folder on which to place the pidfile and some other temporary
#   files for the well functioning of this script (ex: /tmp/status)
#
# [*zookeeper_hosts*]
#   (Mandatory) Comma-separated list of zookeeper hosts. These are a hash consisting of two
#   fields, 'ip' and 'port'. Example: [ { 'ip' => '12.153.140.2', 'port' => '2181'}]
#
# [*api_port*]
#   (Mandatory) Port that the Midonet API binds
#
# [*scripts_dir*]
#   (Optional) Path where to place the necessary scripts
#
# [*ensure_scripts*]
#   (Optional) Status of the scripts
#
# [*mido_keystone_user*]
#   (Optional) Username to authenticate against Keystone
#
# [*mido_keystone_password*]
#   (Optional) Password to authenticate against Keystone
#
# [*mido_project_id*]
#   (Optional) Project id to authenticate in keystone
#
# === Examples
#
# The easiest way to run the class is:
#
#      class { 'midonet::gateway::static':
#        network_id => 'example_netid',
#        cidr => '200.0.0.1/24',
#        gateway_ip => '200.0.0.1',
#        service_host => '127.0.0.1',
#        service_dir => '/tmp/status',
#        zookeeper_hosts => [
#          {
#            'ip'=>'127.0.0.1',
#            'port'=>'2181'
#          }
#        ],
#        api_port => '8181'
#      }
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2016 Midokura SARL, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class midonet::gateway::static (
  $fip,
  $nic,
  $edge_router,
  $veth0_ip,
  $veth1_ip,
  $veth_network,
  $scripts_dir             = '/tmp',
  $uplink_script           = 'create_fake_uplink_l2.sh',
  $ensure_scripts          = 'present',
  $myhostname              = $::hostname,
  $masquerade              = 'on'
) {

  # Place script and helper files before executing it
  file { 'fake_uplink_script':
    ensure  => $ensure_scripts,
    path    => "${scripts_dir}/${uplink_script}",
    content => template('midonet/gateway/create_fake_uplink_l2.sh.erb'),
  }

  # Finally, execute the script
  exec { 'run gateway static creation script':
    command => "/bin/bash -x ${scripts_dir}/${uplink_script} 2>&1 | tee ${scripts_dir}/${uplink_script}.out",
    returns => ['0', '7'],
    timeout => 1800,
    require => [
      File['fake_uplink_script'],
    ]
  }

  # Ensure interfaces are configured and enabled at boot time
  # (for the time being this is RHEL 7.x only)
  if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7' {
    file { 'fake_uplink_script-STARTUP':
      ensure  => $ensure_scripts,
      mode    => '0775',
      path    => '/usr/local/sbin/create_fake_uplink_l2.sh',
      content => template('midonet/gateway/create_fake_uplink_l2.sh.erb'),
    } ->
    file { 'fake_uplink_script-SERVICEFILE':
      ensure => $ensure_scripts,
      mode   => '0644',
      path   => '/etc/systemd/system/midonet-static-uplink.service',
      source => 'puppet:///modules/midonet/gateway/midonet-static-uplink.service',
    } ->
    service { 'midonet-static-uplink': enable => true }
  }
}
