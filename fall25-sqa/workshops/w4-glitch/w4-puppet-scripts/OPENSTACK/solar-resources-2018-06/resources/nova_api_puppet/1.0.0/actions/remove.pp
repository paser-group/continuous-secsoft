class { 'nova::api':
  ensure_package => 'absent',
  enabled        => false,
  admin_password => 'not important as removed'
}

include nova::params

exec { 'post-nova_config':
  command     => '/bin/echo "Nova config has changed"',
  refreshonly => true,
}

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => 'absent',
}
