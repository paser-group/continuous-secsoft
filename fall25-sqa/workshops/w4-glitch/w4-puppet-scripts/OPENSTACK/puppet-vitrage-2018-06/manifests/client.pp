#
# Installs the vitrage python library.
#
# == parameters
# [*ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'
#
class vitrage::client (
  $ensure = 'present'
) {

  include ::vitrage::deps
  include ::vitrage::params

  package { 'python-vitrageclient':
    ensure => $ensure,
    name   => $::vitrage::params::client_package_name,
    tag    => 'openstack',
  }

}

