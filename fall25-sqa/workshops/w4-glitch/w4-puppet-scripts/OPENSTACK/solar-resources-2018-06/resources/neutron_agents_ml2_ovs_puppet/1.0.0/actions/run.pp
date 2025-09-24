$resource = hiera($::resource_name)

$ip = $resource['input']['ip']

$package_ensure              = $resource['input']['package_ensure']
$enabled                     = $resource['input']['enabled']
$bridge_uplinks              = $resource['input']['bridge_uplinks']
$bridge_mappings             = $resource['input']['bridge_mappings']
$integration_bridge          = $resource['input']['integration_bridge']
$enable_tunneling            = $resource['input']['enable_tunneling']
$tunnel_types                = $resource['input']['tunnel_types']
$local_ip                    = $resource['input']['local_ip']
$tunnel_bridge               = $resource['input']['tunnel_bridge']
$vxlan_udp_port              = $resource['input']['vxlan_udp_port']
$polling_interval            = $resource['input']['polling_interval']
$l2_population               = $resource['input']['l2_population']
$arp_responder               = $resource['input']['arp_responder']
$firewall_driver             = $resource['input']['firewall_driver']
$enable_distributed_routing  = $resource['input']['enable_distributed_routing']

class { 'neutron::agents::ml2::ovs':
  enabled                     => true,
  package_ensure              => $package_ensure,
  bridge_uplinks              => $bridge_uplinks,
  bridge_mappings             => $bridge_mappings,
  integration_bridge          => $integration_bridge,
  enable_tunneling            => $enable_tunneling,
  tunnel_types                => $tunnel_types,
  local_ip                    => $local_ip,
  tunnel_bridge               => $tunnel_bridge,
  vxlan_udp_port              => $vxlan_udp_port,
  polling_interval            => $polling_interval,
  l2_population               => $l2_population,
  arp_responder               => $arp_responder,
  firewall_driver             => $firewall_driver,
  enable_distributed_routing  => $enable_distributed_routing,
}

# Remove external class dependency and restore required ones
Service <| title == 'neutron-ovs-agent-service' |> {
  require    => undef
}
Neutron_plugin_ml2<||> ~> Service['neutron-ovs-agent-service']
File <| title == '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini' |> ~>
Service<| title == 'neutron-ovs-agent-service' |>