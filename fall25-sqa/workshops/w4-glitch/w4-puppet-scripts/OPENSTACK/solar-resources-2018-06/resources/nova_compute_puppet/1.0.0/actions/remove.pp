class { 'nova::compute':
  ensure_package => 'absent',
  enabled        => false,
}

include nova::params

exec { 'post-nova_config':
  command     => '/bin/echo "Nova config has changed"',
  refreshonly => true,
}

exec { 'networking-refresh':
  command     => '/sbin/ifdown -a ; /sbin/ifup -a',
}

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => 'absent',
}