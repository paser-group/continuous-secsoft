# == Class: midonet::midonet_cluster
#
# Install and run midonet_cluster
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
#     Default: undef
# [*keystone_tenant_name*]
#   Name of the keystone tenant
#     Default: undef
# [*package_name*]
#   Name of the midonet cluster package
#     Default: undef
# [*package_ensure*]
#   Ensure 'present', 'absent' ...
#     Default: undef
# [*service_name*]
#   Name of the midonet cluster service
#     Default: undef
# [*service_ensure*]
#   Ensure 'running' , 'stopped' ... status of service
#     Default: undef
# [*service_enable*]
#  Should enable service on startup?
#     Default: undef
# [*cluster_config_path*]
#   Path to store the midonet cluster configuration files
#     Default: undef
# [*cluster_jvm_config_path*]
#   Path to store the midonet cluster JVM configuration files
#     Default: undef
# [*cluster_host*]
#   IP to bind to the midonet cluster service
#     Default: undef
# [*cluster_port*]
#   Port to bind the midonet cluster service
#     Default: undef
# [*keystone_port*]
#   Port where the keystone service is running
#     Default: undef
# [*max_heap_size*]
#   Heap size of midonet cluster JVM. Ex '1024M'
#     Default: undef
# [*heap_newsize*]
#   Xmx heap size value in gb . Ex '512M'
#     Default: undef
# [*is_mem*]
#   Whether to install cluster mem packages or not
#     Default: undef
# [*is_insights*]
#  Whether using MEM Insights or not
#     Default: undef
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
#     Default: '5.2'
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
#     Default: 'undef'
# [*endpoint_port*]
#   Where the unified endpoint will bind to ( port )
#     Default: 'undef'
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
#     Default: 'undef'
# [*jarvis_enabled*]
#   Should enable jarvis?
#     Default: 'undef'
# [*state_proxy_address*]
#   Address to bind to the state proxy service
#     Default: undef
# [*state_proxy_port*]
#   Address to bind to the state proxy service
#     Default: undef
#
# === Examples
#
# This would be a deployment for demo purposes
# would be:
#
#    class {'midonet::midonet_cluster':
#        zookeeper_hosts        => [{
#          'ip' => $::ipaddress}
#          ]
#        cassandra_servers      => ['127.0.0.1'],
#        cassandra_rep_factor   => 1.
#        keystone_admin_token   => 'fake_token',
#        keystone_host          => '127.0.0.1'
#    }
#

#
# Please note that Keystone port is not mandatory and defaulted to 35357.
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
class midonet::cluster (
  $zookeeper_hosts,
  $cassandra_servers,
  $cassandra_rep_factor,
  $keystone_host,
  $keystone_protocol         = undef,
  $keystone_admin_token      = undef,
  $keystone_user_name        = undef,
  $keystone_user_password    = undef,
  $keystone_tenant_name      = undef,
  $keystone_domain_name      = undef,
  $keystone_domain_id        = undef,
  $keystone_keystone_version = undef,
  $package_name              = undef,
  $package_ensure            = undef,
  $service_name              = undef,
  $service_ensure            = undef,
  $service_enable            = undef,
  $cluster_config_path       = undef,
  $cluster_jvm_config_path   = undef,
  $cluster_host              = undef,
  $cluster_port              = undef,
  $keystone_port             = undef,
  $max_heap_size             = undef,
  $heap_newsize              = undef,
  $is_mem                    = undef,
  $is_insights               = undef,
  $insights_ssl              = undef,
  $analytics_ip              = undef,
  $midonet_version           = '5.2',
  $elk_seeds                 = undef,
  $cluster_api_address       = $::ipaddress,
  $cluster_api_port          = '8181',
  $elk_cluster_name          = undef,
  $elk_target_endpoint       = undef,
  $endpoint_host             = undef,
  $endpoint_port             = undef,
  $ssl_source_type           = undef,
  $ssl_cert_path             = undef,
  $ssl_privkey_path          = undef,
  $ssl_privkey_pwd           = undef,
  $ssl_keystore_path         = undef,
  $ssl_keystore_pwd          = undef,
  $flow_history_port         = undef,
  $jarvis_enabled            = undef,
  $state_proxy_address       = undef,
  $state_proxy_port          = undef
) {

    class { 'midonet::cluster::install':
      package_ensure => $package_ensure,
      package_name   => $package_name,
      is_mem         => $is_mem
    }
    contain midonet::cluster::install

    class { 'midonet::cluster::run':
      service_name              => $service_name,
      service_ensure            => $service_ensure,
      service_enable            => $service_enable,
      cluster_config_path       => $cluster_config_path,
      cluster_jvm_config_path   => $cluster_jvm_config_path,
      cluster_host              => $cluster_host,
      cluster_port              => $cluster_port,
      max_heap_size             => $max_heap_size,
      heap_newsize              => $heap_newsize,
      zookeeper_hosts           => $zookeeper_hosts,
      cassandra_servers         => $cassandra_servers,
      cassandra_rep_factor      => $cassandra_rep_factor,
      keystone_admin_token      => $keystone_admin_token,
      keystone_host             => $keystone_host,
      keystone_port             => $keystone_port,
      keystone_tenant_name      => $keystone_tenant_name,
      keystone_protocol         => $keystone_protocol,
      keystone_user_name        => $keystone_user_name,
      keystone_user_password    => $keystone_user_password,
      keystone_domain_name      => $keystone_domain_name,
      keystone_domain_id        => $keystone_domain_id,
      keystone_keystone_version => $keystone_keystone_version,
      is_insights               => $is_insights,
      insights_ssl              => $insights_ssl,
      analytics_ip              => $analytics_ip,
      package_ensure            => $package_ensure,
      midonet_version           => $midonet_version,
      elk_seeds                 => $elk_seeds,
      cluster_api_address       => $cluster_api_address,
      cluster_api_port          => $cluster_api_port,
      elk_cluster_name          => $elk_cluster_name,
      elk_target_endpoint       => $elk_target_endpoint,
      endpoint_host             => $endpoint_host,
      endpoint_port             => $endpoint_port,
      ssl_source_type           => $ssl_source_type,
      ssl_cert_path             => $ssl_cert_path,
      ssl_privkey_path          => $ssl_privkey_path,
      ssl_privkey_pwd           => $ssl_privkey_pwd,
      ssl_keystore_path         => $ssl_keystore_path,
      ssl_keystore_pwd          => $ssl_keystore_pwd,
      flow_history_port         => $flow_history_port,
      jarvis_enabled            => $jarvis_enabled,
      state_proxy_address       => $state_proxy_address,
      state_proxy_port          => $state_proxy_port,
      require                   => Class['midonet::cluster::install']
    }
    contain midonet::cluster::run
}
