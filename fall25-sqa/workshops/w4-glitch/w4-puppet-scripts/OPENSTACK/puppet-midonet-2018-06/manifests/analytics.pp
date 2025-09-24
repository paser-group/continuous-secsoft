# == Class: midonet::analytics
#
# Installs midonet analytics packages
#
# === Parameters
#
# [*zookeeper_hosts*]
#   List of hash [{ip, port}] Zookeeper instances that run in cluster.
#
# [*manage_repo*]
#   Boolean variable - If true puppet will install repositories on given node
#     Default: false
#
# [*is_mem*]
#  If using MEM Enterprise , set to true
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
# [*heap_size_gb*]
#  Specify the heap size of the JavaVM in Gb. Ex: '3'
#     Default: '4'
#
# [*allinone*]
#  If doing an allinone deployment, set to true
#     Default: false
#
# [*curator_version*]
#  Version of elastic curator
#     Default: '3.5'
#
# [*calliope_port*]
#  If you want to run calliope on a custom port, specify it
#     Default: false
#
# [*midonet_version*]
#  Version of midonet
#     Default: '5.2'
#
# [*elk_bind_ip*]
#  Where to bind elk instance
#     Default: 'undef' , will bind to $::ipaddress
#
# [*elk_cluster_name*]
#  Name of elk cluster
#     Default: 'elasticsearch'
#
# [*elk_hosts*]
#  List of elk seeds
#     Default: ['$::ipaddress']
#
# Please note that Keystone port is not mandatory and defaulted to 35537.
#
# === Examples
#
# The easiest way to run the class is:
#
#   class {'midonet::analytics':
#      zookeeper_hosts =>  [{'ip'   => 'host1',
#                         'port' => '2183'},
#                         {'ip'   => 'host2'}],
#      is_mem          => true,
#      manage_repo     => false,
#      heap_size_gb    => '3',
#   }
#
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2015 Midokura SARL, All Rights Reserved.
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

class midonet::analytics (
  $zookeeper_hosts,
  $is_mem             = true,
  $manage_repo        = false,
  $mem_username       = undef,
  $mem_password       = undef,
  $heap_size_gb       = '4',
  $allinone           = false,
  $curator_version    = '3.5',
  $calliope_port      = undef,
  $midonet_version    = undef,
  $elk_bind_ip        = undef,
  $elk_cluster_name   = 'elasticsearch',
  $elk_hosts          = [$::ipaddress]
) {
  include ::stdlib
  $logstash_version            = versioncmp($midonet_version,'5.2') ? {'1' => '5.x', default => '1.5'}
  $elastic_version             = versioncmp($midonet_version,'5.2') ? {'1' => '5.x', default => '1.7'}
  $real_analytics_package_name = versioncmp($midonet_version,'5.2') ? {'1' => 'midonet-elk', default => 'midonet-analytics'}

  if versioncmp($midonet_version,'5.2') > 0
  {
    $ins_service_name = 'elasticsearch-instance-es-01'
    $config = {
      'network.host' => ['_local_',$elk_bind_ip],
      'cluster.name' => $elk_cluster_name,
      'discovery.zen.ping.unicast.hosts' => $elk_hosts,
      'discovery.zen.minimum_master_nodes' => (size($elk_hosts)/2)+1
    }

  }
  else {
    $config = undef
    $ins_service_name = 'elasticsearch-instance-es-01'
  }

  class { 'elasticsearch':
    manage_repo  => $manage_repo,
    repo_version => $elastic_version,
    config       => $config,
    require      => Class['::logstash']
  }
  contain elasticsearch

  class { 'logstash':
    manage_repo  => $manage_repo,
    repo_version => $logstash_version,
    purge_config => false,
  }
  contain logstash

  elasticsearch::instance { 'es-01':
    require => Class['::logstash','::elasticsearch']
  }

  if $::osfamily == 'Debian' {
    anchor { 'curator-begin': } ->
    class { 'curator':
      version => $curator_version,
    } ->
    anchor { 'curator-end': }
  }
  elsif $::osfamily == 'RedHat' {
    if $manage_repo {
      exec { 'rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch':
        path => '/usr/bin'
      } ->
      yumrepo { 'curator-3':
        descr    => 'CentOS/RHEL repository for Elasticsearch Curator 3 packages',
        baseurl  => 'http://packages.elastic.co/curator/3/centos/$releasever',
        gpgcheck => true,
        gpgkey   => 'http://packages.elastic.co/GPG-KEY-elasticsearch',
        enabled  => true,
        before   => Package['python-elasticsearch-curator'],
      }
    }
    anchor { 'curator-begin': } ->
    package { 'python-elasticsearch-curator': ensure => installed } ->
    anchor { 'curator-end': }
  }

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
          before            => Class[
            'midonet::analytics::services',
            'midonet::analytics::quickstart'
          ]
        }
      }
    }

    class { 'midonet::analytics::services':
      calliope_port   => $calliope_port,
      midonet_version => $midonet_version,
      require         => [
        Class['::logstash','::elasticsearch'],
        Elasticsearch::Instance['es-01'],
        Anchor['curator-end']
      ]
    }

    unless $allinone {
      if versioncmp($midonet_version,'5.2') > 0
      {
        class { 'midonet::analytics::quickstart':
          zookeeper_hosts => $zookeeper_hosts,
        }
      }
      else {
        class { 'midonet::analytics::quickstart':
          zookeeper_hosts => $zookeeper_hosts,
          notify          => Service['analytics_service']
        }
      }
    }

  }
  else  {
    notice('Skipping installation of midonet analytics services')
  }

  if $::osfamily == 'Debian' {
    $logstash_config_file = '/etc/default/logstash'
    $elasticsearch_config_file = '/etc/default/elasticsearch'
    $logstash_service = 'logstash'
    $elasticsearch_service = 'elasticsearch'
  }
  if $::osfamily == 'RedHat' {
    $logstash_config_file = '/etc/logstash/jvm.options'
    $elasticsearch_config_file = '/etc/elasticsearch/jvm.options'
    $logstash_service = 'logstash'
    $elasticsearch_service = 'elasticsearch'
  }
  file_line { 'Set LS_HEAP_SIZE':
    path    => $logstash_config_file,
    line    => "LS_HEAP_SIZE='${heap_size_gb}g'",
    match   => '^LS_HEAP_SIZE.*$',
    require => Package['logstash'],
    notify  => Service[$ins_service_name],
  }

  file_line { 'Set ES_HEAP_SIZE':
    path    => $elasticsearch_config_file,
    line    => "ES_HEAP_SIZE='${heap_size_gb}g'",
    match   => '^ES_HEAP_SIZE.*$',
    require => Package['elasticsearch'],
    notify  => Service[$ins_service_name],
  }
}

