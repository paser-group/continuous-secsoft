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
notice('MODULAR: midonet-edge-router-cleanup-bgp.pp')

include ::stdlib

$old_config = loadyamlv2('/etc/fuel/cluster/astute.yaml.old','notfound')

# If it's a redeploy and the file exists we can proceed
if($old_config != 'notfound')
{
  $old_gw_type = $old_config['midonet']['gateway_type']
  if ($old_gw_type == 'bgp') {
    # Extract data from hiera
    $access_data           = $old_config['access']
    $management_address    = hiera('management_vip')
    $keystone_admin_tenant = $access_data['tenant']
    $net_metadata          = $old_config['network_metadata']
    $gw_hash               = get_nodes_hash_by_roles($net_metadata, ['midonet-gw'])
    $gw_keys               = keys($gw_hash)
    $neutron_settings      = $old_config['quantum_settings']
    $external_net_name     = $neutron_settings['default_floating_net']
    $tenant_net_name       = $neutron_settings['default_private_net']
    $predefined_nets       = $neutron_settings['predefined_networks']
    $tenant_net            = $predefined_nets[$tenant_net_name]
    $external_net          = $predefined_nets[$external_net_name]

    $username         = $access_data['user']
    $password         = $access_data['password']
    $tenant_name      = $access_data['tenant']

    # Plugin settings data (overrides $external_net l3 values)
    $midonet_settings                = $old_config['midonet']
    $tz_type                         = $midonet_settings['tunnel_type']
    $floating_range_start            = $midonet_settings['floating_ip_range_start']
    $floating_range_end              = $midonet_settings['floating_ip_range_end']
    $floating_cidr                   = $midonet_settings['floating_cidr']
    $floating_gateway_ip             = $midonet_settings['gateway']
    $bgp_local_as                    = $midonet_settings['bgp_local_as']
    $bgp_neighbors                   = $midonet_settings['bgp_neighbors']

    $edge_router = 'edge-router'

    $allocation_pools = "start=${floating_range_start},end=${floating_range_end}"

    $myhostname = $gw_keys[0]

    $ports_to_unbind = generate_router_interfaces_list($bgp_neighbors)


    file { 'delete router interfaces script':
      ensure  => present,
      path    => '/tmp/delete_router_interfaces_bgp.sh',
      content => template('/etc/fuel/plugins/midonet-9.2/puppet/templates/delete_router_interfaces_bgp.sh.erb'),
    }

    # Finally, execute the script
    exec { 'run delete router interfaces script':
      command => '/bin/bash -x /tmp/delete_router_interfaces_bgp.sh 2>&1 | tee /tmp/ri-delete-bgp.out',
      returns => ['0', '7'],
    }

    $defaults_for_subnet = {
      ensure       => absent,
      enable_dhcp  => false,
      network_name => 'edge-net',
      tenant_id    => $external_net['tenant']
    }

    create_resources('neutron_subnet',
                    generate_bgp_edge_subnet_hash($bgp_neighbors),
                    $defaults_for_subnet)

    $defaults_for_port = {
      ensure          => absent,
      network_name    => 'edge-net',
      binding_host_id => $gw_hash[$gw_keys[0]]['fqdn'],
      binding_profile => {
        'interface_name' => 'gw-veth-mn'
      },
    }

    create_resources('neutron_port',
                    generate_bgp_edge_port_hash($bgp_neighbors),
                    $defaults_for_port)

    midonet_gateway_bgp { 'edge-router':
      ensure                  => absent,
      bgp_local_as_number     => $bgp_local_as,
      username                => $username,
      password                => $password,
      tenant_name             => $tenant_name,
      midonet_api_url         => "http://${management_address}:8181/midonet-api",
      bgp_advertised_networks => $floating_cidr,
      bgp_neighbors           => generate_bgp_neighbors_for_gateway_bgp($bgp_neighbors)
    }

    File['delete router interfaces script']
    -> Exec['run delete router interfaces script']
    -> Neutron_subnet<||>
    -> Neutron_port<||>
    -> Midonet_gateway_bgp['edge-router']
  }

}
