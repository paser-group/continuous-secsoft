$service_title           = $resource['input']['title']
$package_name    = $resource['input']['package_name']
$service_name    = $resource['input']['service_name']

exec { 'post-nova_config':
  command     => '/bin/echo "Nova config has changed"',
}

nova::generic_service { $service_title:
  ensure_package => 'absent',
  enabled        => false,
  package_name   => $package_name,
  service_name   => $service_name,
}

include nova::params

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => 'absent',
}