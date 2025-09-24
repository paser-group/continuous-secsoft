# == Class: midonet::cluster::run
# Check out the midonet::cluster class for a full understanding of
# how to use the cluster resource
#
#
# === Parameters
#
# [*zookeeper_hosts*]
#   List of hash [{ip, port}] Zookeeper instances that run in cluster.
# [*cassandra_servers*]
#   List of IP's / IP:PORT where cassandra servers are running
# [*cassandra_rep_factor*]
#   Cassandra replication factor
# [*keystone_admin_token*]
#   Keystone admin token
# [*keystone_host*]
#   Host where keystone is running
# [*keystone_protocol*]
#   Protocol ( http / https ) to make the keystone requests
#     Default: 'http'
# [*keystone_tenant_name*]
#   Name of the keystone tenant
#     Default: 'admin'
# [*package_ensure*]
#   Ensure 'present', 'absent' ...
#     Default: present
# [*service_name*]
#   Name of the midonet cluster service
#     Default: 'midonet_cluster'
# [*service_ensure*]
#   Ensure 'running' , 'stopped' ... status of service
#     Default: running
# [*service_enable*]
#  Should enable service on startup?
#     Default: true
# [*cluster_config_path*]
#   Path to store the midonet cluster configuration files
#     Default: /etc/midonet/midonet.conf
# [*cluster_jvm_config_path*]
#   Path to store the midonet cluster JVM configuration files
#     Default: /etc/midonet-cluster/midonet-cluster-env.sh
# [*cluster_host*]
#   IP to bind to the midonet cluster service
#     Default: '0.0.0.0'
# [*cluster_port*]
#   Port to bind the midonet cluster service
#     Default: '8181'
# [*keystone_port*]
#   Port where the keystone service is running
#     Default: '35357'
# [*max_heap_size*]
#   Heap size of midonet cluster JVM , . Ex: '1024M'
#     Default: '1024M'
# [*heap_newsize*]
#   Xms heap size value in gb . Ex '512M'
#     Default: '512M'
# [*is_insights*]
#  Whether using MEM Insights or not
#     Default: false
# [*insights_ssl*]
#   Is MEM insights using SSL?
#     Default: undef
# [*analytics_ip*]
#   IP of the Analytics node
#     Default: undef
# [*midonet_version*]
#   Version of Midonet
#     Default: '5.2'
# [*elk_seeds*]
#   List of elk seeds , in the form "ip1,ip2,ip3"
#     Default: '$::ipaddress'
# [*cluster_api_address*]
#   IP Address that is publicly exposed for the REST Api . Usually this will be the same as
#   the cluster_host but you might want to configure it in some cases, such as using an haproxy
#   on the front
#     Default: '$::ipaddress'
# [*cluster_api_port*]
#   Port Address that is publicly exposed for the REST Api . Usually this will be the same as
#   the cluster_host but you might want to configure it in some cases, such as using an haproxy
#   on the front. Usually you don't want to modify this
#     Default: '8181'
# [*elk_cluster_name*]
#   Elasticsearch cluster name. Not needed if running in single-elk-node mode
#     Default: 'undef'
# [*elk_target_endpoint*]
#   Configures the elk target endpoint
#     Default: 'undef'
# [*endpoint_host*]
#   Where the unified endpoint will bind to
#     Default: '$::ipaddress'
# [*endpoint_port*]
#   Where the unified endpoint will bind to ( port )
#     Default: '8888'
# [*ssl_source_type*]
#   SSL Source type. 'autosigned' , 'keystore' , 'certificate'
#     Default: 'undef'
# [*ssl_cert_path*]
#   SSL certificate path
#     Default: 'undef'
# [*ssl_privkey_path*]
#   SSL private key path
#     Default: 'undef'
# [*ssl_privkey_pwd*]
#   SSL private key password
#     Default: 'undef'
# [*flow_history_port*]
#   Port for flow history endpoint
#     Default: '5001'
# [*jarvis_enabled*]
#   Should enable jarvis?
#     Default: 'undef'
# [*midonet_version*]
#   Midoent Version
#     Default: '5.2'
# [*state_proxy_address*]
#   Address to bind to the state proxy service
#     Default: undef
# [*state_proxy_port*]
#   Address to bind to the state proxy service
#     Default: undef
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
class midonet::cluster::run (
  $zookeeper_hosts,
  $cassandra_servers,
  $cassandra_rep_factor,
  $keystone_host,
  $keystone_admin_token            = undef,
  $keystone_user_name              = undef,
  $keystone_user_password          = undef,
  $keystone_protocol               = 'http',
  $keystone_port                   = '35357',
  $keystone_tenant_name            = 'admin',
  $keystone_domain_name            = 'Default',
  $keystone_domain_id              = 'default',
  $keystone_keystone_version       = '3',
  $service_name                    = 'midonet-cluster',
  $service_ensure                  = 'running',
  $service_enable                  = true,
  $cluster_config_path             = '/etc/midonet/midonet.conf',
  $cluster_jvm_config_path         = '/etc/midonet-cluster/midonet-cluster-env.sh',
  $cluster_host                    = '0.0.0.0',
  $cluster_port                    = '8181',
  $max_heap_size                   = '1024M',
  $heap_newsize                    = '512M',
  $package_ensure                  = 'present',
  $is_insights                     = false,
  $clio_service_udp_port           = undef,
  $clio_target_udp_port            = undef,
  $jmxscraper_target_udp_endpoint  = undef,
  $flow_tracing_service_ws_port    = undef,
  $agent_flow_history_udp_endpoint = undef,
  $calliope_service_ws_port        = undef,
  $insights_ssl                    = undef,
  $analytics_ip                    = undef,
  $elk_seeds                       = $::ipaddress,
  $cluster_api_address             = $::ipaddress,
  $cluster_api_port                = '8181',
  $elk_cluster_name                = '',
  $elk_target_endpoint             = $::ipaddress,
  $endpoint_host                   = $::ipaddress,
  $endpoint_port                   = '8888',
  $ssl_source_type                 = undef,
  $ssl_cert_path                   = undef,
  $ssl_privkey_path                = undef,
  $ssl_privkey_pwd                 = undef,
  $ssl_keystore_path               = undef,
  $ssl_keystore_pwd                = undef,
  $flow_history_port               = '5001',
  $jarvis_enabled                  = true,
  $midonet_version                 = '5.2',
  $state_proxy_address             = '0.0.0.0',
  $state_proxy_port                = '2346'
) {

  include ::stdlib

  $api_proto      = $insights_ssl? {true => 'https://' , default => 'http://'}
  $mem_login_host = "${api_proto}${cluster_api_address}:${cluster_api_port}/midonet-api"
  $new_api        = versioncmp($midonet_version,'5.2') ? {'1' => true, default => false}

  if $package_ensure != 'absent' {
    file { '/tmp/mn-cluster_config.sh':
      ensure  => present,
      content => template('midonet/cluster/mn-cluster_config.sh.erb'),
    } ->

    exec { '/bin/bash /tmp/mn-cluster_config.sh':
      require => File['set_config'],
    }

    if !defined(File['set_config']) {
      file { 'set_config':
        ensure  => present,
        path    => $cluster_config_path,
        content => template('midonet/cluster/midonet.conf.erb'),
        require => Package['midonet-cluster'],
        notify  => Service['midonet-cluster'],
        before  => File['/tmp/mn-cluster_config.sh'],
      }
    }

    file { 'cluster_jvm_config':
      ensure  => present,
      path    => $cluster_jvm_config_path,
      content => template('midonet/cluster/midonet-cluster-env.sh.erb'),
      require => Package['midonet-cluster'],
      notify  => Service['midonet-cluster'],
    }

    package { 'python-neutron-lbaas': ensure => installed }
    package { 'python-neutron-fwaas': ensure => installed }

    if $is_insights {
      file { 'analytics_settings':
        ensure  => present,
        path    => '/tmp/analytics_settings.conf',
        content => template('midonet/analytics/analytics_settings.erb'),
      } ->
      file { 'analytics_settings_script':
        ensure  => present,
        path    => '/tmp/analytics_settings.sh',
        content => template('midonet/analytics/analytics_settings.sh.erb'),
      } ->
      exec { '/bin/bash /tmp/analytics_settings.sh':
        require => File['set_config'],
      }
      if versioncmp($midonet_version,'5.2') > 0
      {
        file { 'analytics_settings_local':
          ensure  => present,
          path    => '/tmp/analytics_settings_local.conf',
          content => template('midonet/analytics/analytics_settings_local.erb'),
        } ->
        file { 'analytics_settings_script local':
          ensure  => present,
          path    => '/tmp/analytics_settings_local.sh',
          content => template('midonet/analytics/analytics_settings.sh.erb'),
          require => Exec['/bin/bash /tmp/analytics_settings.sh']
        } ->
        # As we will only be deploying MidoNet 5.4 we can set a single notify here
        exec { '/bin/bash /tmp/analytics_settings_local.sh':
          require => File['set_config'],
          notify  => Service['midonet-cluster'],
        }
      }
    }

    file { '/etc/midonet/subscriptions':
      ensure  => directory,
      source  => 'puppet:///modules/midonet/subscriptions',
      require => Service['midonet-cluster'],
      recurse => true,
    }
  }

  service { 'midonet-cluster':
    ensure => $service_ensure,
    name   => $service_name,
    enable => $service_enable,
  }
}
