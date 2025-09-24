$resource = hiera($::resource_name)

$ip = $resource['input']['ip']

$type_drivers               = $resource['input']['type_drivers']
$tenant_network_types       = $resource['input']['tenant_network_types']
$mechanism_drivers          = $resource['input']['mechanism_drivers']
$flat_networks              = $resource['input']['flat_networks']
$network_vlan_ranges        = $resource['input']['network_vlan_ranges']
$tunnel_id_ranges           = $resource['input']['tunnel_id_ranges']
$vxlan_group                = $resource['input']['vxlan_group']
$vni_ranges                 = $resource['input']['vni_ranges']
$enable_security_group      = $resource['input']['enable_security_group']
$package_ensure             = $resource['input']['package_ensure']
$supported_pci_vendor_devs  = $resource['input']['supported_pci_vendor_devs']
$sriov_agent_required       = $resource['input']['sriov_agent_required']

# LP1490438
file {'/etc/default/neutron-server':
    ensure   => present,
    owner    => 'root',
    group    => 'root',
    mode     => 644
} ->

class { 'neutron::plugins::ml2':
  type_drivers               => $type_drivers,
  tenant_network_types       => $tenant_network_types,
  mechanism_drivers          => $mechanism_drivers,
  flat_networks              => $flat_networks,
  network_vlan_ranges        => $network_vlan_ranges,
  tunnel_id_ranges           => $tunnel_id_ranges,
  vxlan_group                => $vxlan_group,
  vni_ranges                 => $vni_ranges,
  enable_security_group      => $enable_security_group,
  package_ensure             => $package_ensure,
  supported_pci_vendor_devs  => $supported_pci_vendor_devs,
  sriov_agent_required       => $sriov_agent_required,
} ->

exec { 'neutron-db-sync':
  provider    => 'shell',
  command     => "${command} stamp head",
  path        => [ '/usr/bin', '/bin' ],
  onlyif      => "${command} current | grep -qE '^Current revision.*None$' "
}

include neutron::params

package { 'neutron':
  ensure => $package_ensure,
  name   => $::neutron::params::package_name,
  before => Exec['neutron-db-sync']
}