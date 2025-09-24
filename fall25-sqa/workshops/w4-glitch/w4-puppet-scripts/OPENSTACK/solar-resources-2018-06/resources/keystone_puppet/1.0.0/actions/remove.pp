class {'keystone':
  admin_token        => '{{ admin_token }}',
  package_ensure     => 'absent'
}
