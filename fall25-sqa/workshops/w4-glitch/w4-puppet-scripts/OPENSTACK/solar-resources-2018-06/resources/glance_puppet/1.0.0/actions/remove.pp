$resource = hiera($::resource_name)

include glance::params

class {'glance':
  package_ensure => 'absent',
}

package { [$glance::params::api_package_name, $::glance::params::package_name] :
  ensure => 'absent',
}
