# == Class: zaqar::client
#
# Installs the zaqar python library.
#
# === Parameters:
#
# [*ensure*]
#   (Optional) Ensure state for pachage.
#   Defaults to 'present'.
#
class zaqar::client (
  $ensure = 'present'
) {

  include ::zaqar::deps
  include ::zaqar::params

  package { 'python-zaqarclient':
    ensure => $ensure,
    name   => $::zaqar::params::client_package_name,
    tag    => 'openstack',
  }

}
