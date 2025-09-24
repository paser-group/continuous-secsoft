class { 'neutron::agents::metadata':
  package_ensure    => 'absent',
  enabled           => false,
}

include neutron::params

package { 'neutron':
  ensure => 'absent',
  name   => $::neutron::params::package_name,
}

# Remove external class dependency
Service <| title == 'neutron-metadata' |> {
  require    => undef
}