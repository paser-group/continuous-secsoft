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
notice('MODULAR: midonet-edge-router-setup.pp')

# Extract data from hiera
$access_data           = hiera_hash('access')
$keystone_admin_tenant = $access_data['tenant']
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

neutron_router { 'edge-router':
  ensure => present,
}

neutron_router_interface { "edge-router:${external_net_name}__subnet":
  ensure => present,
}

neutron_network { 'edge-net':
  ensure                => present,
  tenant_id             => $external_net['tenant'],
  provider_network_type => 'uplink',
}
