# == Class: midonet::agent::run
# Check out the midonet::agent class for a full understanding of
# how to use the agent resource
# DO NOT USE THIS CLASS ON ITS OWN, use ::midonet::agent !
#
# === Parameters
#
#
# [*zookeeper_hosts*]
#   List of hash [{ip, port}] Zookeeper instances that run in cluster.
#
# [*controller_host*]
#   IP of the controller host (or HAProxy ip serving them).
#     Default: undef
#
# [*metadata_port*]
#  Port where the metadata service will run
#     Default: undef
#
# [*shared_secret*]
#  Metadata shared secret
#     Default: undef
#
# [*service_name*]
#  Name of the midolman service
#     Default: midolman
#
# [*service_ensure*]
#  Whether to ensure the service is running, stopped, etc.
#     Default: running
#
# [*service_enable*]
#  Should the service not be enabled by default? Specify it there
#     Default: true
#
# [*agent_config_path*]
#  Override the configuration files path
#     Default: /etc/midolman/midolman.conf
#
# [*jvm_config_path*]
#  Override the jvm config files path
#     Default: /etc/midolman/midolman-env.sh
#
# [*max_heap_size*]
#  Specify the heap size of the JavaVM in Gb. Ex: '1024M'
#     Default: '1024M'
#
# [*dhcp_mtu*]
#  Specify a mtu for packets here.
#     Default: undef
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

class midonet::agent::run (
  $zookeeper_hosts,
  $controller_host,
  $metadata_port,
  $shared_secret,
  $service_name         = 'midolman',
  $service_ensure       = 'running',
  $service_enable       = true,
  $midonet_config_path  = '/etc/midonet/midonet.conf',
  $agent_config_path    = '/etc/midolman/midolman.conf',
  $jvm_config_path      = '/etc/midolman/midolman-env.sh',
  $max_heap_size        = '1024M',
  $dhcp_mtu             = undef
) {

  file { '/tmp/mn-agent_config.sh':
    ensure  => present,
    content => template('midonet/agent/mn-agent_config.sh.erb'),
  } ->

  exec { '/bin/bash /tmp/mn-agent_config.sh': }

  file { 'agent_config':
    ensure  => present,
    path    => $agent_config_path,
    content => template('midonet/agent/midolman.conf.erb'),
    require => Package['midolman'],
    notify  => Service['midolman'],
    before  => File['/tmp/mn-agent_config.sh'],
  }

  if !defined(File['set_config']) {
    file { 'set_config':
      ensure  => present,
      path    => $midonet_config_path,
      content => template('midonet/agent/midolman.conf.erb'),
      require => [
        Package['midolman'],
        File['midonet folder']
      ],
      notify  => Service['midolman'],
      before  => File['/tmp/mn-agent_config.sh'],
    }
  }
  if !defined(File['midonet folder']) {
    file { 'midonet folder':
      ensure => 'directory',
      path   => '/etc/midonet',
      owner  => 'root',
      mode   => '0755',
    }
  }

  file { 'jvm_config':
    ensure  => present,
    path    => $jvm_config_path,
    content => template('midonet/agent/midolman-env.sh.erb'),
    require => Package['midolman'],
    notify  => Service['midolman'],
  }

  service { 'midolman':
    ensure => $service_ensure,
    name   => $service_name,
    enable => $service_enable,
  }
}
