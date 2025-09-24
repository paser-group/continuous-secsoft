#
# Installs the tacker python library.
#
# == parameters
#  [*ensure*]
#    (Optional) ensure state for package.
#    Defaults to 'present'
#
class tacker::client (
  $ensure = 'present'
) {

  include tacker::deps
  include tacker::params

  package { 'python-tackerclient':
    ensure => $ensure,
    name   => $::tacker::params::client_package_name,
    tag    => 'openstack',
  }

}
