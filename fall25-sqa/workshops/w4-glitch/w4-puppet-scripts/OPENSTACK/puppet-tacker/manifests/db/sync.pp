#
# Class to execute tacker-db-manage
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the tacker-dbsync command.
#   Defaults to '--config-file /etc/tacker/tacker.conf'
#
# [*user*]
#   (Optional) User to run dbsync command.
#   Defaults to 'tacker'
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class tacker::db::sync(
  $extra_params    = '--config-file /etc/tacker/tacker.conf',
  $user            = 'tacker',
  $db_sync_timeout = 300,
) {

  include tacker::deps

  exec { 'tacker-db-sync':
    command     => "tacker-db-manage ${extra_params} upgrade head",
    path        => ['/bin', '/usr/bin'],
    user        => $user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['tacker::install::end'],
      Anchor['tacker::config::end'],
      Anchor['tacker::dbsync::begin']
    ],
    notify      => Anchor['tacker::dbsync::end'],
    tag         => 'openstack-db',
  }

}
