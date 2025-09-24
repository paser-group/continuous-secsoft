$resource = hiera($::resource_name)

$libvirt_virt_type                           = $resource['input']['libvirt_virt_type']
$vncserver_listen                            = $resource['input']['vncserver_listen']
$migration_support                           = $resource['input']['migration_support']
$libvirt_cpu_mode                            = $resource['input']['libvirt_cpu_mode']
$libvirt_disk_cachemodes                     = $resource['input']['libvirt_disk_cachemodes']
$libvirt_inject_password                     = $resource['input']['libvirt_inject_password']
$libvirt_inject_key                          = $resource['input']['libvirt_inject_key']
$libvirt_inject_partition                    = $resource['input']['libvirt_inject_partition']
$remove_unused_base_images                   = $resource['input']['remove_unused_base_images']
$remove_unused_kernels                       = $resource['input']['remove_unused_kernels']
$remove_unused_resized_minimum_age_seconds   = $resource['input']['remove_unused_resized_minimum_age_seconds']
$remove_unused_original_minimum_age_seconds  = $resource['input']['remove_unused_original_minimum_age_seconds']
$libvirt_service_name                        = $resource['input']['libvirt_service_name']
$libvirt_type                                = $resource['input']['libvirt_type']

class { 'nova::compute::libvirt':
  libvirt_virt_type                           => $libvirt_virt_type,
  vncserver_listen                            => $vncserver_listen,
  migration_support                           => $migration_support,
  libvirt_cpu_mode                            => $libvirt_cpu_mode,
  libvirt_disk_cachemodes                     => $libvirt_disk_cachemodes,
  libvirt_inject_password                     => $libvirt_inject_password,
  libvirt_inject_key                          => $libvirt_inject_key,
  libvirt_inject_partition                    => $libvirt_inject_partition,
  remove_unused_base_images                   => $remove_unused_base_images,
  remove_unused_kernels                       => $remove_unused_kernels,
  remove_unused_resized_minimum_age_seconds   => $remove_unused_resized_minimum_age_seconds,
  remove_unused_original_minimum_age_seconds  => $remove_unused_original_minimum_age_seconds,
  libvirt_service_name                        => $libvirt_service_name,
  libvirt_type                                => $libvirt_type,
}

#exec { 'networking-refresh':
#  command     => '/sbin/ifdown -a ; /sbin/ifup -a',
#}

#exec { 'post-nova_config':
#  command     => '/bin/echo "Nova config has changed"',
#}

include nova::params

service { 'nova-compute':
  name => $::nova::params::compute_service_name,
}

package { 'nova-compute':
  name => $::nova::params::compute_package_name,
}

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => $ensure_package,
}
