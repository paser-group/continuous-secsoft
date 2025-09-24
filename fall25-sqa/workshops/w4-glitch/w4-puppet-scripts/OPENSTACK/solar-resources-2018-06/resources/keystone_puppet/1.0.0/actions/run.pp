$resource = hiera($::resource_name)

$ip = $resource['input']['ip']
$admin_token = $resource['input']['admin_token']
$db_user = $resource['input']['db_user']
$db_host = $resource['input']['db_host']
$db_password = $resource['input']['db_password']
$db_name = $resource['input']['db_name']
$db_port = $resource['input']['db_port']
$admin_port = $resource['input']['admin_port']
$port = $resource['input']['port']

class {'keystone':
  package_ensure       => 'present',
  verbose              => true,
  catalog_type         => 'sql',
  admin_token          => $admin_token,
  database_connection  => "mysql://$db_user:$db_password@$db_host:$db_port/$db_name",
  public_port          => "$port",
  admin_port           => "$admin_port",
  token_driver         => 'keystone.token.persistence.backends.sql.Token'
}

#file { '/etc/keystone/keystone-exports':
#  owner     => 'root',
#  group     => 'root',
#  content   => template('keystone/exports.erb')
#}
