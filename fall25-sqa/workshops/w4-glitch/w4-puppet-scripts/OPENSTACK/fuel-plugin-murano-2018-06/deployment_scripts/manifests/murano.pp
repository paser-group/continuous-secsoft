notice('MURANO PLUGIN: murano.pp')

prepare_network_config(hiera_hash('network_scheme', {}))

$murano_hash                = hiera_hash('murano_plugin', {})
$murano_plugins             = pick($murano_hash['plugins'], {})
$rabbit_hash                = hiera_hash('rabbit', {})
$neutron_config             = hiera_hash('neutron_config', {})
$public_ssl_hash            = hiera_hash('public_ssl', {})
$ssl_hash                   = hiera_hash('use_ssl', {})
$external_dns               = hiera_hash('external_dns', {})
$primary_murano             = roles_include(['primary-murano-node', 'primary-controller'])
$public_ip                  = hiera('public_vip')
$database_ip                = hiera('database_vip')
$management_ip              = hiera('management_vip')
$region                     = hiera('region', 'RegionOne')
$use_neutron                = hiera('use_neutron', false)
$service_endpoint           = hiera('service_endpoint')
$syslog_log_facility_murano = hiera('syslog_log_facility_murano')
$debug                      = pick($murano_hash['debug'], hiera('debug', false))
$verbose                    = pick($murano_hash['verbose'], hiera('verbose', true))
$default_log_levels         = hiera_hash('default_log_levels', {})
$use_syslog                 = hiera('use_syslog', true)
$use_stderr                 = hiera('use_stderr', false)
$rabbit_ha_queues           = hiera('rabbit_ha_queues', false)
$amqp_port                  = hiera('amqp_port')
$amqp_hosts                 = hiera('amqp_hosts')

$internal_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
$internal_auth_address  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_ip])
$admin_auth_protocol    = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'protocol', 'http')
$admin_auth_address     = get_ssl_property($ssl_hash, {}, 'keystone', 'admin', 'hostname', [hiera('keystone_endpoint', ''), $service_endpoint, $management_ip])
$api_bind_host          = get_network_role_property('management', 'ipaddr')

if $use_neutron {
  $external_network = try_get_value($neutron_config, 'default_floating_net', 'net04_ext')
  $default_router   = 'murano-default-router'
} else {
  $external_network = undef
  $default_router   = undef
}

$firewall_rule = '202 murano-api'
$api_bind_port = '8082'

$murano_user     = pick($murano_hash['user'], 'murano')
$murano_password = $murano_hash['user_password']
$tenant          = pick($murano_hash['tenant'], 'services')

$db_type     = 'mysql'
$db_user     = pick($murano_hash['db_user'], 'murano')
$db_name     = pick($murano_hash['db_name'], 'murano')
$db_password = pick($murano_hash['db_password'])
$db_host     = pick($murano_hash['db_host'], $database_ip)
# LP#1526938 - python-mysqldb supports this, python-pymysql does not
if $::os_package_type == 'debian' {
  $extra_params = { 'charset' => 'utf8', 'read_timeout' => 60 }
} else {
  $extra_params = { 'charset' => 'utf8' }
}
$db_connection = os_database_connection({
  'dialect'  => $db_type,
  'host'     => $db_host,
  'database' => $db_name,
  'username' => $db_user,
  'password' => $db_password,
  'extra'    => $extra_params
})

$repository_url = has_key($murano_hash, 'murano_repo_url') ? {
  true    => $murano_hash['murano_repo_url'],
  default => 'http://storage.apps.openstack.org',
}

####### Disable upstart startup on install #######
tweaks::ubuntu_service_override { ['murano-api', 'murano-engine']:
  package_name => 'murano',
}

include ::firewall
firewall { $firewall_rule :
  dport  => $api_bind_port,
  proto  => 'tcp',
  action => 'accept',
}

if $murano_plugins and has_key($murano_plugins, 'glance_artifacts_plugin') and $murano_plugins['glance_artifacts_plugin']['enabled'] {
  $packages_service = 'glare'
} else {
  $packages_service = 'murano'
}

class { '::murano' :
  verbose             => $verbose,
  package_ensure      => 'latest',
  debug               => $debug,
  use_syslog          => $use_syslog,
  use_stderr          => $use_stderr,
  log_facility        => $syslog_log_facility_murano,
  database_connection => $db_connection,
  sync_db             => $primary_murano,
  auth_uri            => "${internal_auth_protocol}://${internal_auth_address}:5000/",
  admin_user          => $murano_user,
  admin_password      => $murano_password,
  admin_tenant_name   => $tenant,
  identity_uri        => "${admin_auth_protocol}://${admin_auth_address}:35357/",
  notification_driver => 'messagingv2',
  use_neutron         => $use_neutron,
  packages_service    => $packages_service,
  rabbit_os_user      => $rabbit_hash['user'],
  rabbit_os_password  => $rabbit_hash['password'],
  rabbit_os_port      => $amqp_port,
  rabbit_os_host      => $amqp_hosts,
  rabbit_ha_queues    => $rabbit_ha_queues,
  rabbit_own_host     => $public_ip,
  rabbit_own_port     => $murano_hash['rabbit']['port'],
  rabbit_own_vhost    => $murano_hash['rabbit']['vhost'],
  rabbit_own_user     => $murano_hash['rabbit']['user'],
  rabbit_own_password => $murano_hash['rabbit']['password'],
  default_router      => $default_router,
  default_nameservers => join($external_dns['dns_list'], ','),
  service_host        => $api_bind_host,
  service_port        => $api_bind_port,
  external_network    => $external_network,
  use_trusts          => true,
}

class { '::murano::api':
  host           => $api_bind_host,
  port           => $api_bind_port,
  package_ensure => 'latest',
}

class { '::murano::client':
  package_ensure => 'latest'
}

class { '::murano::engine':
  package_ensure => 'latest'
}

Firewall[$firewall_rule] -> Class['murano::api']
