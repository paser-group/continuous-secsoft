# == Class: octavia::client
#
# Installs the octavia python library.
#
# === Parameters
#
# [*ensure*]
#   (Optional) Ensure state for package.
#
class octavia::client (
  $ensure = 'present'
) {

  include ::octavia::deps
  include ::octavia::params

  if $::octavia::params::client_package_name {
    package { 'python-octaviaclient':
      ensure => $ensure,
      name   => $::octavia::params::client_package_name,
      tag    => 'openstack',
    }
  } else {
    fail("There is no avaiable client package in osfamily: ${::osfamily}.")
  }
}
