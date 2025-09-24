# == Class: watcher::client
#
# Installs the watcher python library.
#
# === Parameters:
#
# [*ensure*]
#   (Optional) Ensure state for pachage.
#   Defaults to 'present'.
#
class watcher::client (
  $ensure = 'present'
) {

  include ::watcher::deps
  include ::watcher::params

  package { 'python-watcherclient':
    ensure => $ensure,
    name   => $::watcher::params::client_package_name,
    tag    => 'openstack',
  }

}
