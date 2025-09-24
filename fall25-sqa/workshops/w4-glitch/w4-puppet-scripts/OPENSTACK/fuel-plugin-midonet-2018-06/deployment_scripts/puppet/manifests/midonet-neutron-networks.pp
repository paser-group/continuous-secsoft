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
notice('MODULAR: midonet-neutron-networks.pp')

# Extract data from hiera
$access_data           = hiera_hash('access')
$keystone_admin_tenant = $access_data['tenant']
$net_metadata          = hiera_hash('network_metadata')
$neutron_settings      = hiera('neutron_config')
$external_net_name     = $neutron_settings['default_floating_net']
$tenant_net_name       = $neutron_settings['default_private_net']
$predefined_nets       = $neutron_settings['predefined_networks']
$tenant_net            = $predefined_nets[$tenant_net_name]
$external_net          = $predefined_nets[$external_net_name]

# Plugin settings data (overrides $external_net l3 values)
$midonet_settings     = hiera_hash('midonet')
$tz_type              = $midonet_settings['tunnel_type']
$floating_range_start = $midonet_settings['floating_ip_range_start']
$floating_range_end   = $midonet_settings['floating_ip_range_end']
$floating_cidr        = $midonet_settings['floating_cidr']
$floating_gateway_ip  = $midonet_settings['gateway']

$allocation_pools = "start=${floating_range_start},end=${floating_range_end}"

service { 'neutron-server':
  ensure => running,
}

neutron_network { $tenant_net_name:
  ensure          => present,
  router_external => $tenant_net['L2']['router_ext'],
  tenant_name     => $tenant_net['tenant'],
  shared          => $tenant_net['shared']
} ->

neutron_subnet { "${tenant_net_name}__subnet":
  ensure          => present,
  cidr            => $tenant_net['L3']['subnet'],
  network_name    => $tenant_net_name,
  tenant_name     => $tenant_net['tenant'],
  gateway_ip      => $tenant_net['L3']['gateway'],
  enable_dhcp     => $tenant_net['L3']['enable_dhcp'],
  dns_nameservers => $tenant_net['L3']['nameservers']
} ->

neutron_network { $external_net_name:
  ensure          => present,
  router_external => $external_net['L2']['router_ext'],
  tenant_name     => $external_net['tenant'],
  shared          => $external_net['shared']
} ->

neutron_subnet { "${external_net_name}__subnet":
  ensure           => present,
  cidr             => $floating_cidr,
  network_name     => $external_net_name,
  tenant_name      => $external_net['tenant'],
  gateway_ip       => $floating_gateway_ip,
  enable_dhcp      => $external_net['L3']['enable_dhcp'],
  dns_nameservers  => $external_net['L3']['nameservers'],
  allocation_pools => $allocation_pools
} ->

neutron_router { 'mido_router':
  ensure               => present,
  tenant_name          => $external_net['tenant'],
  gateway_network_name => $external_net_name,
} ->

neutron_router_interface { "mido_router:${tenant_net_name}__subnet":
  ensure => present,
}
