class { 'neutron::agents::ml2::ovs':
  package_ensure    => 'absent',
  enabled           => false,
}