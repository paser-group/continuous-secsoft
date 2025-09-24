#
# Installs the aodh python client.
#
# == parameters
#  [*ensure*]
#   (optional) Ensure state of the package.
#   Defaults to 'present'.
#
class aodh::client (
  $ensure = 'present'
) {

  include ::aodh::deps
  include ::aodh::params

  package { 'python-aodhclient':
    ensure => $ensure,
    name   => $::aodh::params::client_package_name,
    tag    => 'openstack',
  }

}

