class {'apache':
  service_enable     => false,
  service_ensure     => 'stopped',
  package_ensure     => 'absent',
}
