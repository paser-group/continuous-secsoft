class { 'neutron':
  enabled           => false,
  package_ensure    => 'absent',
  rabbit_password   => 'not important as removed',
}