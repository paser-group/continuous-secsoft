#
# Class to execute vitrage-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the vitrage-dbsync command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class vitrage::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include vitrage::deps

  exec { 'vitrage-db-sync':
    command     => "vitrage-dbsync ${extra_params}",
    path        => '/usr/bin',
    user        => 'vitrage',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['vitrage::install::end'],
      Anchor['vitrage::config::end'],
      Anchor['vitrage::dbsync::begin']
    ],
    notify      => Anchor['vitrage::dbsync::end'],
    tag         => 'openstack-db',
  }

}
