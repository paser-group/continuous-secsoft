#
# Class to execute watcher-db-manage upgrade
# It's because watcher-db-manage doesn't support sync db.
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the watcher-db-manage upgrade command.
#   Defaults to '--config-file /etc/watcher/watcher.conf'
#
class watcher::db::upgrade(
  $extra_params  = '--config-file /etc/watcher/watcher.conf',
) {

  include ::watcher::deps

  exec { 'watcher-db-manage-upgrade':
    command     => "watcher-db-manage ${extra_params} upgrade",
    path        => '/usr/bin',
    user        => 'watcher',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['watcher::install::end'],
      Anchor['watcher::config::end'],
      Anchor['watcher::db::create_schema::end'],
      Anchor['watcher::db::upgrade::begin']
    ],
    notify      => Anchor['watcher::db::upgrade::end'],
  }

}
