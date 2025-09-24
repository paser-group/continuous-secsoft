#
# Class to execute watcher-db-manage create_schema
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the watcher-db-manage create_schema command.
#   Defaults to '--config-file /etc/watcher/watcher.conf'
#
class watcher::db::create_schema(
  $extra_params  = '--config-file /etc/watcher/watcher.conf',
) {

  include ::watcher::deps

  exec { 'watcher-db-manage-create_schema':
    command     => "watcher-db-manage ${extra_params} create_schema",
    path        => '/usr/bin',
    user        => 'watcher',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['watcher::install::end'],
      Anchor['watcher::config::end'],
      Anchor['watcher::db::create_schema::begin']
    ],
    notify      => Anchor['watcher::db::create_schema::end'],
    tag         => 'openstack-db',
  }

}
