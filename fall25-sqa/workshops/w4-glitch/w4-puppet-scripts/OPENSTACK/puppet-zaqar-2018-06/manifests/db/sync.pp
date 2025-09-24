#
# Class to execute "zaqar-sql-db-manage upgrade head"
#
class zaqar::db::sync {

  include ::zaqar::deps

  exec { 'zaqar-db-sync':
    command     => 'zaqar-sql-db-manage upgrade head',
    path        => '/usr/bin',
    user        => 'zaqar',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['zaqar::install::end'],
      Anchor['zaqar::config::end'],
      Anchor['zaqar::dbsync::begin']
    ],
    notify      => Anchor['zaqar::dbsync::end'],
    tag         => 'openstack-db',
  }

}
