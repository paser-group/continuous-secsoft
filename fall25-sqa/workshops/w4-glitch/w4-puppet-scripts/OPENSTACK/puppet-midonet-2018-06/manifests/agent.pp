# == Class: midonet::agent
#
# Install and run midonet_agent
#
# === Parameters
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
# [*package_name*]
#  Name of the midonet agent (midolman) package.
#     Default: undef
#
# [*service_name*]
#  Name of the midolman service
#     Default: undef
#
# [*service_ensure*]
#  Whether to ensure the service is running, stopped, etc.
#     Default: undef
#
# [*service_enable*]
#  Should the service not be enabled by default? Specify it there
#     Default: undef
#
# [*agent_config_path*]
#  Override the configuration files path
#     Default: undef
#
# [*package_ensure*]
#  If you want to specify a version for the midolman package, use this parameters
#     Default: undef
#
# [*manage_java*]
#  If the host doesn't have a Java installation, setting this to true will install Java8
#     Default: undef
#
# [*max_heap_size*]
#  Specify the heap size of the JavaVM. Ex: '512M'
#     Default: undef
#
# [*is_mem*]
#  If using MEM Enterprise , set to true
#     Default: undef
#
# [*manage_repo*]
#  Should manage midonet repositories?
#     Default: undef
#
# [*mem_username*]
#  If manage_repo is true and is_mem then specify the username to access the packages
#     Default: undef
#
# [*mem_password*]
#  If manage_repo is true and is_mem then specify the password to access the packages
#     Default: undef
#
# [*dhcp_mtu*]
#  Specify a mtu for packets here.
#     Default: undef
#
# === Examples
#
# The easiest way to run the class is:
#
#     class {'::midonet::agent':
#     zookeeper_hosts =>  [{'ip'   => 'host1',
#                         'port' => '2183'},
#                         {'ip'   => 'host2'}],
#      shared_secret   => 's3cr3t',
#      controller_host => $::ipaddress
#     }
#
# This call assumes that there is no mem being used, and the controller host is same
# that where midolman is being installed
#
# Please note that Zookeeper port is not mandatory and defaulted to 2181
#
# You can alternatively use the Hiera.yaml style:
#
# midonet::agent::zookeeper_hosts:
#     - ip: 'host1'
#       port: 2183
#     - ip: 'host2'
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

class midonet::agent (
  $zookeeper_hosts,
  $controller_host,
  $metadata_port,
  $shared_secret,
  $package_name       = undef,
  $service_name       = undef,
  $service_ensure     = undef,
  $service_enable     = undef,
  $agent_config_path  = undef,
  $package_ensure     = undef,
  $manage_java        = undef,
  $max_heap_size      = undef,
  $is_mem             = false,
  $manage_repo        = false,
  $mem_username       = undef,
  $mem_password       = undef,
  $dhcp_mtu           = undef
) {

  class { 'midonet::agent::install':
    package_name   => $package_name,
    package_ensure => $package_ensure,
    manage_java    => $manage_java,
  }
  contain midonet::agent::install

  class { 'midonet::agent::run':
    service_name      => $service_name,
    service_ensure    => undef,
    service_enable    => undef,
    agent_config_path => $agent_config_path,
    zookeeper_hosts   => $zookeeper_hosts,
    controller_host   => $controller_host,
    metadata_port     => $metadata_port,
    shared_secret     => $shared_secret,
    max_heap_size     => $max_heap_size,
    dhcp_mtu          => $dhcp_mtu,
    require           => Class['midonet::agent::install'],
  }
  contain midonet::agent::run

  if $is_mem {
    if $manage_repo == true {
      if !defined(Class['midonet::repository']) {
        class {'midonet::repository':
          is_mem            => $is_mem,
          midonet_version   => undef,
          midonet_stage     => undef,
          openstack_release => undef,
          mem_version       => undef,
          mem_username      => $mem_username,
          mem_password      => $mem_password,
          before            => Class['midonet::agent::scrapper']
        }
        contain midonet::repository
      }
    }
    class { 'midonet::agent::scrapper':
    }
    contain midonet::agent::scrapper
  }
  else  {
    notice('Skipping installation of jmx-scrapper')
  }

}
