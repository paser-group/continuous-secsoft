$resource = hiera($::resource_name)

$ip = $resource['input']['ip']

$db_user = $resource['input']['db_user']
$db_password = $resource['input']['db_password']
$db_name = $resource['input']['db_name']
$db_host = $resource['input']['db_host']
$db_port = $resource['input']['db_port']

$keystone_password      = $resource['input']['keystone_password']
$package_ensure         = $resource['input']['package_ensure']
$verbose                = $resource['input']['verbose']
$debug                  = $resource['input']['debug']
$bind_host              = $resource['input']['bind_host']
$bind_port              = $resource['input']['bind_port']
$log_file               = $resource['input']['log_file']
$log_dir                = $resource['input']['log_dir']
$database_connection    = $resource['input']['database_connection']
$database_idle_timeout  = $resource['input']['database_idle_timeout']
$auth_type              = $resource['input']['auth_type']
$auth_host              = $resource['input']['auth_host']
$auth_port              = $resource['input']['auth_port']
$auth_admin_prefix      = $resource['input']['auth_admin_prefix']
$auth_uri               = $resource['input']['auth_uri']
$auth_protocol          = $resource['input']['auth_protocol']
$keystone_tenant        = $resource['input']['keystone_tenant']
$keystone_user          = $resource['input']['keystone_user']
$pipeline               = $resource['input']['pipeline']
$use_syslog             = $resource['input']['use_syslog']
$log_facility           = $resource['input']['log_facility']
$purge_config           = $resource['input']['purge_config']
$cert_file              = $resource['input']['cert_file']
$key_file               = $resource['input']['key_file']
$ca_file                = $resource['input']['ca_file']
$sync_db                = $resource['input']['sync_db']
$mysql_module           = $resource['input']['mysql_module']
$sql_idle_timeout       = $resource['input']['sql_idle_timeout']
$sql_connection         = $resource['input']['sql_connection']

include glance::params

class {'glance::registry':
  keystone_password      => $keystone_password,
  enabled                => true,
  manage_service         => true,
  package_ensure         => $package_ensure,
  verbose                => $verbose,
  debug                  => $debug,
  bind_host              => $bind_host,
  bind_port              => $bind_port,
  log_file               => $log_file,
  log_dir                => $log_dir,
  database_connection    => "mysql://${db_user}:${db_password}@${db_host}:${db_port}/${db_name}",
  database_idle_timeout  => $database_idle_timeout,
  auth_type              => $auth_type,
  auth_host              => $auth_host,
  auth_port              => $auth_port,
  auth_admin_prefix      => $auth_admin_prefix,
  auth_uri               => $auth_uri,
  auth_protocol          => $auth_protocol,
  keystone_tenant        => $keystone_tenant,
  keystone_user          => $keystone_user,
  pipeline               => $pipeline,
  use_syslog             => $use_syslog,
  log_facility           => $log_facility,
  purge_config           => $purge_config,
  cert_file              => $cert_file,
  key_file               => $key_file,
  ca_file                => $ca_file,
  sync_db                => $sync_db,
  mysql_module           => $mysql_module,
  sql_idle_timeout       => $sql_idle_timeout,
}

notify { "restart glance registry":
  notify => Service["glance-registry"],
}
