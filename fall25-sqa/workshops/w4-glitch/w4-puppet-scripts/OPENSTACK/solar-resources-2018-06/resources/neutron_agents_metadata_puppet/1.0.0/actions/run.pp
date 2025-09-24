$resource = hiera($::resource_name)

$ip = $resource['input']['ip']

$auth_host          = $resource['input']['auth_host']
$auth_port          = $resource['input']['auth_port']

$auth_password              = $resource['input']['auth_password']
$shared_secret              = $resource['input']['shared_secret']
$package_ensure             = $resource['input']['package_ensure']
$debug                      = $resource['input']['debug']
$auth_tenant                = $resource['input']['auth_tenant']
$auth_user                  = $resource['input']['auth_user']
$auth_insecure              = $resource['input']['auth_insecure']
$auth_ca_cert               = $resource['input']['auth_ca_cert']
$auth_region                = $resource['input']['auth_region']
$metadata_ip                = $resource['input']['metadata_ip']
$metadata_port              = $resource['input']['metadata_port']
$metadata_workers           = $resource['input']['metadata_workers']
$metadata_backlog           = $resource['input']['metadata_backlog']
$metadata_memory_cache_ttl  = $resource['input']['metadata_memory_cache_ttl']

class { 'neutron::agents::metadata':
  enabled                    => true,
  manage_service             => true,
  auth_password              => $auth_password,
  shared_secret              => $shared_secret,
  package_ensure             => $package_ensure,
  debug                      => $debug,
  auth_tenant                => $auth_tenant,
  auth_user                  => $auth_user,
  auth_url                   => "http://${auth_host}:${auth_port}/v2.0",
  auth_insecure              => $auth_insecure,
  auth_ca_cert               => $auth_ca_cert,
  auth_region                => $auth_region,
  metadata_ip                => $metadata_ip,
  metadata_port              => $metadata_port,
  metadata_workers           => $metadata_workers,
  metadata_backlog           => $metadata_backlog,
  metadata_memory_cache_ttl  => $metadata_memory_cache_ttl,
}

include neutron::params

package { 'neutron':
  ensure => $package_ensure,
  name   => $::neutron::params::package_name,
}

# Remove external class dependency
Service <| title == 'neutron-metadata' |> {
  require    => undef
}