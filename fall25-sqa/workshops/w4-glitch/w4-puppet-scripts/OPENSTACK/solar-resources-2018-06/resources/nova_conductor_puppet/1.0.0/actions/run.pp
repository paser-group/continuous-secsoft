$resource = hiera($::resource_name)

$ensure_package                        = $resource['input']['ensure_package']
$workers                               = $resource['input']['workers']

exec { 'post-nova_config':
  command     => '/bin/echo "Nova config has changed"',
}

include nova::params

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => $ensure_package,
}

class { 'nova::conductor':
  enabled                               => true,
  manage_service                        => true,
  ensure_package                        => $ensure_package,
  workers                               => $workers,
}
