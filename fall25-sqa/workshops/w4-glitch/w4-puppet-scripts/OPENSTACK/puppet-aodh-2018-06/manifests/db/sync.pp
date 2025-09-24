#
# Class to execute "aodh-dbsync"
#
# [*user*]
#   (optional) User to run dbsync command.
#   Defaults to 'aodh'
#
class aodh::db::sync (
  $user = 'aodh',
){

  include ::aodh::deps

  exec { 'aodh-db-sync':
    command     => 'aodh-dbsync --config-file /etc/aodh/aodh.conf',
    path        => '/usr/bin',
    refreshonly => true,
    user        => $user,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['aodh::install::end'],
      Anchor['aodh::config::end'],
      Anchor['aodh::dbsync::begin']
    ],
    notify      => Anchor['aodh::dbsync::end'],
    tag         => 'openstack-db',
  }

}
