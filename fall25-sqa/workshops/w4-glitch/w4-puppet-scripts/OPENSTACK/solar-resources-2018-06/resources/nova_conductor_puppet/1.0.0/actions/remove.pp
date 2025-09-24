class { 'nova::conductor':
  ensure_package => 'absent',
  enabled        => false,
}

include nova::params

package { 'nova-common':
  name   => $nova::params::common_package_name,
  ensure => 'absent',
}