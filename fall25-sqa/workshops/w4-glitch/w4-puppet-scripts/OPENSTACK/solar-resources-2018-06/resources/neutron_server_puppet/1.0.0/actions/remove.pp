class { 'neutron::server':
  enabled         => false,
  package_ensure  => 'absent',
  auth_password   => 'not important as removed',
}

# Remove external class dependency
Service <| title == 'neutron-server' |> {
  require    => undef
}