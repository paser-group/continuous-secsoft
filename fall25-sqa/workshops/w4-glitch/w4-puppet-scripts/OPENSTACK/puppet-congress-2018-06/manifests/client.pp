#
# Installs the congress python library.
#
# == parameters
#  [*ensure*]
#   (Optional) ensure state for pachage.
#   Defaults to 'present'
#
class congress::client (
  $ensure = 'present'
) {

  include ::congress::deps
  include ::congress::params

  package { 'python-congressclient':
    ensure => $ensure,
    name   => $::congress::params::client_package_name,
    tag    => 'openstack',
  }

}
