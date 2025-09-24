#
# Class to execute congress-manage db_sync
#
# == Parameters
#
# [*user*]
#   (optional) User to run dbsync command.
#   Defaults to 'congress'
#
class congress::db::sync(
  $user = 'congress',
) {

  include ::congress::deps

  exec { 'congress-db-sync':
    command     => 'congress-db-manage --config-file /etc/congress/congress.conf upgrade head',
    path        => ['/bin', '/usr/bin'],
    user        => $user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => 'on_failure',
    subscribe   => [
      Anchor['congress::install::end'],
      Anchor['congress::config::end'],
      Anchor['congress::dbsync::begin']
    ],
    notify      => Anchor['congress::dbsync::end'],
    tag         => 'openstack-db',
  }

}
