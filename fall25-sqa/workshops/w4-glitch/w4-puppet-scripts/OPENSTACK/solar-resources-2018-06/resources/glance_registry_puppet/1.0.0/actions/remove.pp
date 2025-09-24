$resource = hiera($::resource_name)

class {'glance::registry':
  enabled           => false,
  package_ensure    => 'absent',
  keystone_password => 'not important as removed'
}
