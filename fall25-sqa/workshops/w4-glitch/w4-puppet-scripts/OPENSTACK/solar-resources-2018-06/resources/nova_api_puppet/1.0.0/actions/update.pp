$resource = hiera($::resource_name)

$ensure_package                        = $resource['input']['ensure_package']
$auth_strategy                         = $resource['input']['auth_strategy']
$auth_host                             = $resource['input']['auth_host']
$auth_port                             = $resource['input']['auth_port']
$auth_protocol                         = $resource['input']['auth_protocol']
$auth_uri                              = $resource['input']['auth_uri']
$auth_admin_prefix                     = $resource['input']['auth_admin_prefix']
$auth_version                          = $resource['input']['auth_version']
$admin_tenant_name                     = $resource['input']['admin_tenant_name']
$admin_user                            = $resource['input']['admin_user']
$admin_password                        = $resource['input']['admin_password']
$api_bind_address                      = $resource['input']['api_bind_address']
$metadata_listen                       = $resource['input']['metadata_listen']
$enabled_apis                          = $resource['input']['enabled_apis']
$keystone_ec2_url                      = $resource['input']['keystone_ec2_url']
$volume_api_class                      = $resource['input']['volume_api_class']
$use_forwarded_for                     = $resource['input']['use_forwarded_for']
$osapi_compute_workers                 = $resource['input']['osapi_compute_workers']
$ec2_workers                           = $resource['input']['ec2_workers']
$metadata_workers                      = $resource['input']['metadata_workers']
$sync_db                               = $resource['input']['sync_db']
$neutron_metadata_proxy_shared_secret  = $resource['input']['neutron_metadata_proxy_shared_secret']
$osapi_v3                              = $resource['input']['osapi_v3']
$pci_alias                             = $resource['input']['pci_alias']
$ratelimits                            = $resource['input']['ratelimits']
$ratelimits_factory                    = $resource['input']['ratelimits_factory']
$validate                              = $resource['input']['validate']
$validation_options                    = $resource['input']['validation_options']
$workers                               = $resource['input']['workers']
$conductor_workers                     = $resource['input']['conductor_workers']

exec { 'post-nova_config':
  command     => '/bin/echo "Nova config has changed"',
}

include nova::params

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => $ensure_package,
}

class { 'nova::api':
  enabled                               => true,
  manage_service                        => true,
  ensure_package                        => $ensure_package,
  auth_strategy                         => $auth_strategy,
  auth_host                             => $auth_host,
  auth_port                             => $auth_port,
  auth_protocol                         => $auth_protocol,
  auth_uri                              => $auth_uri,
  auth_admin_prefix                     => $auth_admin_prefix,
  auth_version                          => $auth_version,
  admin_tenant_name                     => $admin_tenant_name,
  admin_user                            => $admin_user,
  admin_password                        => $admin_password,
  api_bind_address                      => $api_bind_address,
  metadata_listen                       => $metadata_listen,
  enabled_apis                          => $enabled_apis,
  keystone_ec2_url                      => $keystone_ec2_url,
  volume_api_class                      => $volume_api_class,
  use_forwarded_for                     => $use_forwarded_for,
  osapi_compute_workers                 => $osapi_compute_workers,
  ec2_workers                           => $ec2_workers,
  metadata_workers                      => $metadata_workers,
  sync_db                               => $sync_db,
  neutron_metadata_proxy_shared_secret  => $neutron_metadata_proxy_shared_secret,
  osapi_v3                              => $osapi_v3,
  pci_alias                             => $pci_alias,
  ratelimits                            => $ratelimits,
  ratelimits_factory                    => $ratelimits_factory,
  validate                              => $validate,
  validation_options                    => $validation_options,
  workers                               => $workers,
  conductor_workers                     => $conductor_workers,
}

notify { "restart nova api":
  notify => Service["nova-api"],
}
