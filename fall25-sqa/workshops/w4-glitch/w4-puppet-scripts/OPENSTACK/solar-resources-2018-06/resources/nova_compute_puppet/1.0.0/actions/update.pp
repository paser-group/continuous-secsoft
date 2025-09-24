$resource = hiera($::resource_name)

$ensure_package                      = $resource['input']['ensure_package']
$vnc_enabled                         = $resource['input']['vnc_enabled']
$vncserver_proxyclient_address       = $resource['input']['vncserver_proxyclient_address']
$vncproxy_host                       = $resource['input']['vncproxy_host']
$vncproxy_protocol                   = $resource['input']['vncproxy_protocol']
$vncproxy_port                       = $resource['input']['vncproxy_port']
$vncproxy_path                       = $resource['input']['vncproxy_path']
$vnc_keymap                          = $resource['input']['vnc_keymap']
$force_config_drive                  = $resource['input']['force_config_drive']
$virtio_nic                          = $resource['input']['virtio_nic']
$neutron_enabled                     = $resource['input']['neutron_enabled']
$network_device_mtu                  = $resource['input']['network_device_mtu']
$instance_usage_audit                = $resource['input']['instance_usage_audit']
$instance_usage_audit_period         = $resource['input']['instance_usage_audit_period']
$force_raw_images                    = $resource['input']['force_raw_images']
$reserved_host_memory                = $resource['input']['reserved_host_memory']
$compute_manager                     = $resource['input']['compute_manager']
$pci_passthrough                     = $resource['input']['pci_passthrough']
$default_availability_zone           = $resource['input']['default_availability_zone']
$default_schedule_zone               = $resource['input']['default_schedule_zone']
$internal_service_availability_zone  = $resource['input']['internal_service_availability_zone']

class { 'nova::compute':
  enabled                             => true,
  manage_service                      => true,
  ensure_package                      => $ensure_package,
  vnc_enabled                         => $vnc_enabled,
  vncserver_proxyclient_address       => $vncserver_proxyclient_address,
  vncproxy_host                       => $vncproxy_host,
  vncproxy_protocol                   => $vncproxy_protocol,
  vncproxy_port                       => $vncproxy_port,
  vncproxy_path                       => $vncproxy_path,
  vnc_keymap                          => $vnc_keymap,
  force_config_drive                  => $force_config_drive,
  virtio_nic                          => $virtio_nic,
  neutron_enabled                     => $neutron_enabled,
  network_device_mtu                  => $network_device_mtu,
  instance_usage_audit                => $instance_usage_audit,
  instance_usage_audit_period         => $instance_usage_audit_period,
  force_raw_images                    => $force_raw_images,
  reserved_host_memory                => $reserved_host_memory,
  compute_manager                     => $compute_manager,
  pci_passthrough                     => $pci_passthrough,
  default_availability_zone           => $default_availability_zone,
  default_schedule_zone               => $default_schedule_zone,
  internal_service_availability_zone  => $internal_service_availability_zone,
}

exec { 'networking-refresh':
  command     => '/sbin/ifdown -a ; /sbin/ifup -a',
}

exec { 'post-nova_config':
  command     => '/bin/echo "Nova config has changed"',
}

include nova::params

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => $ensure_package,
}

notify { "restart nova compute":
  notify => Service["nova-compute"],
}
