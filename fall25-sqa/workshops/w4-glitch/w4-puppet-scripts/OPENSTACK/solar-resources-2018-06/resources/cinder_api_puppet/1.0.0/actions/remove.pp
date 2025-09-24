class {'cinder::api':
  enabled            => false,
  package_ensure     => 'absent',
  keystone_password  => 'not important as removed',
}

include cinder::params

package { 'cinder':
  ensure  => 'absent',
  name    => $::cinder::params::package_name,
}