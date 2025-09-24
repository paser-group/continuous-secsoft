$resource = hiera($::resource_name)

$ip = $resource['input']['ip']

$db_user = $resource['input']['db_user']
$db_host = $resource['input']['db_host']
$db_port = $resource['input']['db_port']
$db_password = $resource['input']['db_password']
$db_name = $resource['input']['db_name']

$package_ensure            = $resource['input']['package_ensure']
$auth_password             = $resource['input']['auth_password']
$auth_type                 = $resource['input']['auth_type']
$auth_host                 = $resource['input']['auth_host']
$auth_port                 = $resource['input']['auth_port']
$auth_admin_prefix         = $resource['input']['auth_admin_prefix']
$auth_tenant               = $resource['input']['auth_tenant']
$auth_user                 = $resource['input']['auth_user']
$auth_protocol             = $resource['input']['auth_protocol']
$auth_uri                  = $resource['input']['auth_uri']
$database_max_retries      = $resource['input']['database_max_retries']
$database_idle_timeout     = $resource['input']['database_idle_timeout']
$database_retry_interval   = $resource['input']['database_retry_interval']
$database_min_pool_size    = $resource['input']['database_min_pool_size']
$database_max_pool_size    = $resource['input']['database_max_pool_size']
$database_max_overflow     = $resource['input']['database_max_overflow']
$sync_db                   = $resource['input']['sync_db']
$api_workers               = $resource['input']['api_workers']
$rpc_workers               = $resource['input']['rpc_workers']
$agent_down_time           = $resource['input']['agent_down_time']
$router_scheduler_driver   = $resource['input']['router_scheduler_driver']
$router_distributed        = $resource['input']['router_distributed']
$l3_ha                     = $resource['input']['l3_ha']
$max_l3_agents_per_router  = $resource['input']['max_l3_agents_per_router']
$min_l3_agents_per_router  = $resource['input']['min_l3_agents_per_router']
$l3_ha_net_cidr            = $resource['input']['l3_ha_net_cidr']
$mysql_module              = $resource['input']['mysql_module']
$sql_max_retries           = $resource['input']['sql_max_retries']
$max_retries               = $resource['input']['max_retries']
$sql_idle_timeout          = $resource['input']['sql_idle_timeout']
$idle_timeout              = $resource['input']['idle_timeout']
$sql_reconnect_interval    = $resource['input']['sql_reconnect_interval']
$retry_interval            = $resource['input']['retry_interval']
$log_dir                   = $resource['input']['log_dir']
$log_file                  = $resource['input']['log_file']
$report_interval           = $resource['input']['report_interval']

class { 'neutron::server':
  enabled                   => true,
  manage_service            => true,
  database_connection       => "mysql://${db_user}:${db_password}@${db_host}:${db_port}/${db_name}",
  package_ensure            => $package_ensure,
  auth_password             => $auth_password,
  auth_type                 => $auth_type,
  auth_host                 => $auth_host,
  auth_port                 => $auth_port,
  auth_admin_prefix         => $auth_admin_prefix,
  auth_tenant               => $auth_tenant,
  auth_user                 => $auth_user,
  auth_protocol             => $auth_protocol,
  auth_uri                  => $auth_uri,
  database_max_retries      => $database_max_retries,
  database_idle_timeout     => $database_idle_timeout,
  database_retry_interval   => $database_retry_interval,
  database_min_pool_size    => $database_min_pool_size,
  database_max_pool_size    => $database_max_pool_size,
  database_max_overflow     => $database_max_overflow,
  sync_db                   => $sync_db,
  api_workers               => $api_workers,
  rpc_workers               => $rpc_workers,
  agent_down_time           => $agent_down_time,
  router_scheduler_driver   => $router_scheduler_driver,
  router_distributed        => $router_distributed,
  l3_ha                     => $l3_ha,
  max_l3_agents_per_router  => $max_l3_agents_per_router,
  min_l3_agents_per_router  => $min_l3_agents_per_router,
  l3_ha_net_cidr            => $l3_ha_net_cidr,
  mysql_module              => $mysql_module,
  sql_max_retries           => $sql_max_retries,
  max_retries               => $max_retries,
  sql_idle_timeout          => $sql_idle_timeout,
  idle_timeout              => $idle_timeout,
  sql_reconnect_interval    => $sql_reconnect_interval,
  retry_interval            => $retry_interval,
  log_dir                   => $log_dir,
  log_file                  => $log_file,
  report_interval           => $report_interval,
}

# Remove external class dependency
Service <| title == 'neutron-server' |> {
  require    => undef
}
