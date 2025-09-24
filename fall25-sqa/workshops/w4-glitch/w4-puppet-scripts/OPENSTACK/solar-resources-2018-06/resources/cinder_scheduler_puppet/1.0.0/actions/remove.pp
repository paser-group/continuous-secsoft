class {'cinder::scheduler':
  enabled            => false,
  package_ensure     => 'absent',
}
