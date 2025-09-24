class { 'neutron::agents::l3':
  package_ensure    => 'absent',
  enabled           => false,
}

include neutron::params

package { 'neutron':
  ensure => 'absent',
  name   => $::neutron::params::package_name,
}

# Remove external class dependency
Service <| title == 'neutron-l3' |> {
  require    => undef
}