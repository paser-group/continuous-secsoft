$resource = hiera($::resource_name)

$ip = $resource['input']['ip']

$db_user = $resource['input']['db_user']
$db_password = $resource['input']['db_password']
$db_name = $resource['input']['db_name']
$db_host = $resource['input']['db_host']
$db_port = $resource['input']['db_port']

$filesystem_store_datadir = $resource['input']['filesystem_store_datadir']

$keystone_password          = $resource['input']['keystone_password']
$verbose                   = $resource['input']['verbose']
$debug                     = $resource['input']['debug']
$bind_host                 = $resource['input']['bind_host']
$bind_port                 = $resource['input']['bind_port']
$backlog                   = $resource['input']['backlog']
$workers                   = $resource['input']['workers']
$log_file                  = $resource['input']['log_file']
$log_dir                   = $resource['input']['log_dir']
$registry_host             = $resource['input']['registry_host']
$registry_port             = $resource['input']['registry_port']
$registry_client_protocol  = $resource['input']['registry_client_protocol']
$auth_type                 = $resource['input']['auth_type']
$auth_host                 = $resource['input']['auth_host']
$auth_url                  = $resource['input']['auth_url']
$auth_port                 = $resource['input']['auth_port']
$auth_uri                  = $resource['input']['auth_uri']
$auth_admin_prefix         = $resource['input']['auth_admin_prefix']
$auth_protocol             = $resource['input']['auth_protocol']
$pipeline                  = $resource['input']['pipeline']
$keystone_tenant           = $resource['input']['keystone_tenant']
$keystone_user             = $resource['input']['keystone_user']
$use_syslog                = $resource['input']['use_syslog']
$log_facility              = $resource['input']['log_facility']
$show_image_direct_url     = $resource['input']['show_image_direct_url']
$purge_config              = $resource['input']['purge_config']
$cert_file                 = $resource['input']['cert_file']
$key_file                  = $resource['input']['key_file']
$ca_file                   = $resource['input']['ca_file']
$known_stores              = $resource['input']['known_stores']
$database_connection       = $resource['input']['database_connection']
$database_idle_timeout     = $resource['input']['database_idle_timeout']
$image_cache_dir           = $resource['input']['image_cache_dir']
$os_region_name            = $resource['input']['os_region_name']
$validate                  = $resource['input']['validate']
$validation_options        = $resource['input']['validation_options']
$mysql_module              = $resource['input']['mysql_module']
$sql_idle_timeout          = $resource['input']['sql_idle_timeout']

class {'glance':
  package_ensure => 'present',
}

class {'glance::api':
  keystone_password         => $keystone_password,
  enabled                   => true,
  manage_service            => true,
  verbose                   => $verbose,
  debug                     => $debug,
  bind_host                 => $bind_host,
  bind_port                 => $bind_port,
  backlog                   => $backlog,
  workers                   => $workers,
  log_file                  => $log_file,
  log_dir                   => $log_dir,
  registry_host             => $registry_host,
  registry_port             => $registry_port,
  registry_client_protocol  => $registry_client_protocol,
  auth_type                 => $auth_type,
  auth_host                 => $auth_host,
  auth_url                  => $auth_url,
  auth_port                 => $auth_port,
  auth_uri                  => $auth_uri,
  auth_admin_prefix         => $auth_admin_prefix,
  auth_protocol             => $auth_protocol,
  pipeline                  => $pipeline,
  keystone_tenant           => $keystone_tenant,
  keystone_user             => $keystone_user,
  use_syslog                => $use_syslog,
  log_facility              => $log_facility,
  show_image_direct_url     => $show_image_direct_url,
  purge_config              => $purge_config,
  cert_file                 => $cert_file,
  key_file                  => $key_file,
  ca_file                   => $ca_file,
  known_stores              => $known_stores,
  database_connection       => "mysql://${db_user}:${db_password}@${db_host}:${db_port}/${db_name}",
  database_idle_timeout     => $database_idle_timeout,
  image_cache_dir           => $image_cache_dir,
  os_region_name            => $os_region_name,
  validate                  => $validate,
  validation_options        => $validation_options,
  mysql_module              => $mysql_module,
  sql_idle_timeout          => $sql_idle_timeout,
}

class { 'glance::backend::file':
  filesystem_store_datadir => $filesystem_store_datadir,
}
