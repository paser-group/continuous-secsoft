#
# Class to execute octavia-db-manage upgrade head
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the octavia-dbsync command.
#   Defaults to undef
#
class octavia::db::sync(
  $extra_params  = undef,
) {

  include ::octavia::deps

  exec { 'octavia-db-sync':
    command     => "octavia-db-manage upgrade head ${extra_params}",
    path        => '/usr/bin',
    user        => 'octavia',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['octavia::install::end'],
      Anchor['octavia::config::end'],
      Anchor['octavia::dbsync::begin']
    ],
    notify      => Anchor['octavia::dbsync::end'],
    tag         => 'openstack-db',
  }

}
