class {'cinder::volume':
  enabled            => false,
  package_ensure     => 'absent',
}
