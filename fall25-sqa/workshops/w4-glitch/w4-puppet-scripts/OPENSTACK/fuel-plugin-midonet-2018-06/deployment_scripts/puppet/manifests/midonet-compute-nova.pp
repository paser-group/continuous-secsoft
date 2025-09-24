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
notice('MODULAR: neutron-compute-nova.pp')

$network_scheme = hiera_hash('network_scheme', {})
prepare_network_config($network_scheme)

$use_neutron = hiera('use_neutron', false)

include nova::params
$neutron_config             = hiera_hash('neutron_config', {})
$neutron_integration_bridge = 'br-int'
$nova_hash                  = hiera_hash('nova', {})
$libvirt_vif_driver         = pick($nova_hash['libvirt_vif_driver'], 'nova.virt.libvirt.vif.LibvirtGenericVIFDriver')

$management_vip             = hiera('management_vip')
$service_endpoint           = hiera('service_endpoint', $management_vip)
$admin_password             = try_get_value($neutron_config, 'keystone/admin_password')
$admin_tenant_name          = try_get_value($neutron_config, 'keystone/admin_tenant', 'services')
$admin_username             = try_get_value($neutron_config, 'keystone/admin_user', 'neutron')
$region_name                = hiera('region', 'RegionOne')
$auth_api_version           = 'v3'
$ssl_hash                   = hiera_hash('use_ssl', {})

$admin_identity_protocol    = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'protocol', 'http')
$admin_identity_address     = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'hostname', [$service_endpoint, $management_vip])

$neutron_internal_protocol  = get_ssl_property($ssl_hash, {}, 'neutron', 'internal', 'protocol', 'http')
$neutron_endpoint           = get_ssl_property($ssl_hash, {}, 'neutron', 'internal', 'hostname', [hiera('neutron_endpoint', ''), $management_vip])

$admin_identity_uri         = "${admin_identity_protocol}://${admin_identity_address}:35357"
$admin_auth_url             = "${admin_identity_uri}/${auth_api_version}"
$neutron_url                = "${neutron_internal_protocol}://${neutron_endpoint}:9696"

$nova_migration_ip          =  get_network_role_property('nova/migration', 'ipaddr')

service { 'libvirt' :
  ensure   => 'running',
  enable   => true,
  # Workaround for bug LP #1469308
  # also service name for Ubuntu and Centos is the same.
  name     => 'libvirtd',
  provider => $nova::params::special_service_provider,
}

firewall { '999 accept all to metadata interface':
  proto   => 'all',
  iniface => 'metadata',
  action  => 'accept',
}

exec { 'destroy_libvirt_default_network':
  command => 'virsh net-destroy default',
  onlyif  => 'virsh net-info default | grep -qE "Active:.* yes"',
  path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
  tries   => 3,
  require => Service['libvirt'],
}

exec { 'undefine_libvirt_default_network':
  command => 'virsh net-undefine default',
  onlyif  => 'virsh net-info default 2>&1 > /dev/null',
  path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
  tries   => 3,
  require => Exec['destroy_libvirt_default_network'],
}

Service['libvirt'] ~> Exec['destroy_libvirt_default_network']

# script called by qemu needs to manipulate the tap device
file_line { 'clear_emulator_capabilities':
  path   => '/etc/libvirt/qemu.conf',
  line   => 'clear_emulator_capabilities = 0',
  notify => Service['libvirt']
}

class { 'nova::compute::neutron':
  libvirt_vif_driver => $libvirt_vif_driver,
}

nova_config {
  'DEFAULT/linuxnet_interface_driver':       value => 'nova.network.linux_net.LinuxOVSInterfaceDriver';
  'DEFAULT/linuxnet_ovs_integration_bridge': value => $neutron_integration_bridge;
  'DEFAULT/network_device_mtu':              value => '65000';
  'DEFAULT/my_ip':                           value => $nova_migration_ip;
  'DEFAULT/force_config_drive':              value => 'False';
}

class { 'nova::network::neutron' :
  neutron_admin_password    => $admin_password,
  neutron_admin_tenant_name => $admin_tenant_name,
  neutron_region_name       => $region_name,
  neutron_admin_username    => $admin_username,
  neutron_admin_auth_url    => $admin_auth_url,
  neutron_url               => $neutron_url,
  neutron_ovs_bridge        => $neutron_integration_bridge,
}

augeas { 'sysctl-net.bridge.bridge-nf-call-arptables':
  context => '/files/etc/sysctl.conf',
  changes => "set net.bridge.bridge-nf-call-arptables '1'",
  before  => Service['libvirt'],
}
augeas { 'sysctl-net.bridge.bridge-nf-call-iptables':
  context => '/files/etc/sysctl.conf',
  changes => "set net.bridge.bridge-nf-call-iptables '1'",
  before  => Service['libvirt'],
}
augeas { 'sysctl-net.bridge.bridge-nf-call-ip6tables':
  context => '/files/etc/sysctl.conf',
  changes => "set net.bridge.bridge-nf-call-ip6tables '1'",
  before  => Service['libvirt'],
}

service { 'nova-compute':
  ensure => 'running',
  name   => $::nova::params::compute_service_name,
}
Nova_config<| |> ~> Service['nova-compute']

if($::operatingsystem == 'Ubuntu') {
  tweaks::ubuntu_service_override { 'nova-network':
    package_name => 'nova-network',
  }
}
