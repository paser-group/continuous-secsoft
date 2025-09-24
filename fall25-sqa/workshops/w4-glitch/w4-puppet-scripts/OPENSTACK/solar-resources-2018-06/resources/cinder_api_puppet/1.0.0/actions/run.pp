$resource = hiera($::resource_name)

$keystone_password           = $resource['input']['keystone_password']
$keystone_enabled            = $resource['input']['keystone_enabled']
$keystone_tenant             = $resource['input']['keystone_tenant']
$keystone_user               = $resource['input']['keystone_user']
$keystone_auth_host          = $resource['input']['keystone_auth_host']
$keystone_auth_port          = $resource['input']['keystone_auth_port']
$keystone_auth_protocol      = $resource['input']['keystone_auth_protocol']
$keystone_auth_admin_prefix  = $resource['input']['keystone_auth_admin_prefix']
$keystone_auth_uri           = $resource['input']['keystone_auth_uri']
$os_region_name              = $resource['input']['os_region_name']
$service_port                = $resource['input']['service_port']
$service_workers             = $resource['input']['service_workers']
$package_ensure              = $resource['input']['package_ensure']
$bind_host                   = $resource['input']['bind_host']
$ratelimits                  = $resource['input']['ratelimits']
$default_volume_type         = $resource['input']['default_volume_type']
$ratelimits_factory          = $resource['input']['ratelimits_factory']
$validate                    = $resource['input']['validate']
$validation_options          = $resource['input']['validation_options']

include cinder::params

package { 'cinder':
  ensure  => $package_ensure,
  name    => $::cinder::params::package_name,
} ->

class {'cinder::api':
  keystone_password           => $keystone_password,
  keystone_enabled            => $keystone_enabled,
  keystone_tenant             => $keystone_tenant,
  keystone_user               => $keystone_user,
  keystone_auth_host          => $keystone_auth_host,
  keystone_auth_port          => $keystone_auth_port,
  keystone_auth_protocol      => $keystone_auth_protocol,
  keystone_auth_admin_prefix  => $keystone_auth_admin_prefix,
  keystone_auth_uri           => $keystone_auth_uri,
  os_region_name              => $os_region_name,
  service_port                => $service_port,
  service_workers             => $service_workers,
  package_ensure              => $package_ensure,
  bind_host                   => $bind_host,
  enabled                     => true,
  manage_service              => true,
  ratelimits                  => $ratelimits,
  default_volume_type         => $default_volume_type,
  ratelimits_factory          => $ratelimits_factory,
  validate                    => $validate,
  validation_options          => $validation_options,
}
