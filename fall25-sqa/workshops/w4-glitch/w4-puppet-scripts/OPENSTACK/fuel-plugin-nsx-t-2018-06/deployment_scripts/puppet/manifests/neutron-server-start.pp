notice('fuel-plugin-nsx-t: neutron-server-start.pp')

include ::neutron::params

service { 'neutron-server-start':
  ensure     => 'running',
  name       => $::neutron::params::server_service,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
}

include ::nsxt::params

neutron_config {
  'DEFAULT/core_plugin':                value => $::nsxt::params::core_plugin;
  'DEFAULT/service_plugins':            ensure => absent;
  'service_providers/service_provider': ensure => absent;
}

Neutron_config<||> ~> Service['neutron-server']

if 'primary-controller' in hiera('roles') {
  include ::neutron::db::sync

  Exec['neutron-db-sync'] ~> Service['neutron-server-start']
  Neutron_config<||> ~> Exec['neutron-db-sync']

  $neutron_config         = hiera_hash('neutron_config')
  $management_vip         = hiera('management_vip')
  $service_endpoint       = hiera('service_endpoint', $management_vip)
  $ssl_hash               = hiera_hash('use_ssl', {})
  $internal_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
  $internal_auth_address  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [$service_endpoint])
  $identity_uri           = "${internal_auth_protocol}://${internal_auth_address}:5000"
  $auth_api_version       = 'v2.0'
  $auth_url               = "${identity_uri}/${auth_api_version}"
  $auth_password          = $neutron_config['keystone']['admin_password']
  $auth_user              = pick($neutron_config['keystone']['admin_user'], 'neutron')
  $auth_tenant            = pick($neutron_config['keystone']['admin_tenant'], 'services')
  $auth_region            = hiera('region', 'RegionOne')
  $auth_endpoint_type     = 'internalURL'

  exec { 'waiting-for-neutron-api':
    environment => [
      "OS_TENANT_NAME=${auth_tenant}",
      "OS_USERNAME=${auth_user}",
      "OS_PASSWORD=${auth_password}",
      "OS_AUTH_URL=${auth_url}",
      "OS_REGION_NAME=${auth_region}",
      "OS_ENDPOINT_TYPE=${auth_endpoint_type}",
    ],
    path        => '/usr/sbin:/usr/bin:/sbin:/bin',
    tries       => '30',
    try_sleep   => '15',
    command     => 'neutron net-list --http-timeout=4 2>&1 > /dev/null',
    provider    => 'shell',
    subscribe   => Service['neutron-server'],
    refreshonly => true,
  }
}

# fix add plugin.ini conf for neutron server
exec { 'fix-plugin-ini':
  path      => '/usr/sbin:/usr/bin:/sbin:/bin',
  command   => 'sed -ri \'s|NEUTRON_PLUGIN_CONFIG=""|NEUTRON_PLUGIN_CONFIG="/etc/neutron/plugin.ini"|\' /usr/share/neutron-common/plugin_guess_func',
  provider  => 'shell',
  before    => Service['neutron-server'],
}
