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
notice('MODULAR: midonet-neutron-configure.pp')

# Neutron data
$amqp_port             = '5673'
$rabbit_hash           = hiera('rabbit', {})
$management_vip        = hiera('management_vip')
$service_endpoint      = hiera('service_endpoint', $management_vip)
$neutron_config        = hiera('quantum_settings')
$neutron_db_password   = $neutron_config['database']['passwd']
$neutron_user_password = $neutron_config['keystone']['admin_password']

$neutron_username        = pick($neutron_config['keystone']['admin_user'], 'neutron')
$neutron_project_name    = pick($neutron_config['keystone']['admin_tenant'], 'services')
$region_name             = hiera('region', 'RegionOne')
$auth_endpoint_type      = 'internalURL'

$ssl_hash                = hiera_hash('use_ssl', {})

$internal_auth_protocol  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
$internal_auth_endpoint  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [$service_endpoint, $management_vip])

# Neutron plugin data
$access_data      = hiera_hash('access')
$username         = $access_data['user']
$password         = $access_data['password']
$tenant_name      = $access_data['tenant']

$openstack_network_hash = hiera_hash('openstack_network', { })
$use_syslog             = hiera('use_syslog', true)
$use_stderr             = hiera('use_stderr', false)
$verbose                = pick($openstack_network_hash['verbose'], hiera('verbose', true))

$primary_ctrl = hiera('primary_controller')


# Unfortunately, core_plugin in the 'openstack-network-common-config'
# task is hardcoded. The core_plugin value for midonet is overrided
# in hiera file, so running again class{'::neutron'} should modify
# the core_plugin value in /etc/neutron/neutron.conf.
# Same goes for service_plugins
#
# Hoping that Fuel will make the core plugin configurable and we
# can remove this step
class {'::neutron':
  verbose                 => $verbose,
  debug                   => false,
  use_syslog              => $use_syslog,
  use_stderr              => $use_stderr,
  log_facility            => 'LOG_USER',
  base_mac                => 'fa:16:3e:00:00:00',
  allow_overlapping_ips   => true,
  mac_generation_retries  => '32',
  dhcp_agent_notification => false,
  report_interval         => '10',
  rabbit_user             => $rabbit_hash['user'],
  rabbit_host             => ['localhost'],
  rabbit_hosts            => split(hiera('amqp_hosts', ''), ','),
  rabbit_port             => '5672',
  rabbit_password         => $rabbit_hash['password'],
  kombu_reconnect_delay   => '5.0',
  network_device_mtu      => undef,
  advertise_mtu           => true
} ->

# NOTE: Don't comment these lines. Since we have changed the name
# of the package, we are trying to get rid of this restriction:
# https://github.com/openstack/puppet-neutron/blob/7.0.0/manifests/plugins/midonet.pp#L108
package {'python-neutron-plugin-midonet':
  ensure => absent
}

file {'/etc/default/neutron-server':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644'
} ->
class { '::midonet::neutron_plugin':
    midonet_api_ip    => $service_endpoint,
    midonet_api_port  => '8181',
    keystone_username => $username,
    keystone_password => $password,
    keystone_tenant   => $tenant_name,
    sync_db           => $primary_ctrl ? {true => true,default => false},
  }


class { '::neutron::server':
  sync_db                 => $primary_ctrl ? {true => 'primary',default => 'slave'},

  username                => $neutron_username,
  password                => $neutron_user_password,

  auth_uri                => "${internal_auth_protocol}://${internal_auth_endpoint}:5000/",
  auth_url                => "${internal_auth_protocol}://${internal_auth_endpoint}:35357/",

  region_name             => $region_name,
  project_name            => $neutron_project_name,

  database_retry_interval => 2,
  database_connection     => "mysql://${neutron_username}:${neutron_db_password}@${service_endpoint}/neutron?&read_timeout=60",
  database_max_retries    => -1,

  agent_down_time         => 15,

  api_workers             => min($::processorcount + 0, 50 + 0),
  rpc_workers             => 0,
}

if !defined(Neutron_config['service_providers/service_provider'])
{
# The version of puppet-neutron included in Fuel 9 doesnt allow passing in service_providers option
# so let's override it directly
  neutron_config {
    'service_providers/service_provider': value => ['LOADBALANCER:Midonet:midonet.neutron.services.loadbalancer.driver.MidonetLoadbalancerDriver:default']
  }
  Class['::midonet::neutron_plugin'] -> Neutron_config['service_providers/service_providers'] -> Service['neutron-server']
}

Neutron_config<| title == 'service_providers/service_provider' |> {
  value => ['LOADBALANCER:Midonet:midonet.neutron.services.loadbalancer.driver.MidonetLoadbalancerDriver:default']
}


# Nova notifications needed data
$nova_endpoint           = hiera('nova_endpoint', $management_vip)
$nova_hash               = hiera_hash('nova', {})
$nova_internal_protocol  = get_ssl_property($ssl_hash, {}, 'nova', 'internal', 'protocol', 'http')
$nova_internal_endpoint  = get_ssl_property($ssl_hash, {}, 'nova', 'internal', 'hostname', [$nova_endpoint])
$admin_auth_protocol     = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'protocol', 'http')
$admin_auth_endpoint     = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'hostname', [$service_endpoint, $management_vip])

# Actual attributes
$nova_url                = "${nova_internal_protocol}://${nova_internal_endpoint}:8774/v2"
$nova_admin_auth_url     = "${admin_auth_protocol}://${admin_auth_endpoint}:35357/"
$nova_auth_user          = pick($nova_hash['user'], 'nova')
$nova_auth_tenant        = pick($nova_hash['tenant'], 'services')
$nova_auth_password      = $nova_hash['user_password']
$auth_region             = hiera('region', 'RegionOne')

class { 'neutron::server::notifications':
  nova_url    => $nova_url,
  auth_url    => $nova_admin_auth_url,
  username    => $nova_auth_user,
  tenant_name => $nova_auth_tenant,
  password    => $nova_auth_password,
  region_name => $auth_region,
}
