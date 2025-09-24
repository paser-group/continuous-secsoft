class { 'neutron::agents::dhcp':
  package_ensure    => 'absent',
  enabled           => false,
}

include neutron::params

package { 'neutron':
  ensure => 'absent',
  name   => $::neutron::params::package_name,
}

# Remove external class dependency
Service <| title == 'neutron-dhcp-service' |> {
  require    => undef
}