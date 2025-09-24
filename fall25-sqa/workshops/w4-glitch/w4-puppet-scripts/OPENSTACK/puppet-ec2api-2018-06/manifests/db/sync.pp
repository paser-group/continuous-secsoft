# == Class: ec2api::db::sync
#
# Class to execute "ec2api-manage db_sync"
#
# === Parameters
#
# [*system_user*]
#   Run db_sync from this system user account.
#   Default: ec2api
#
# [*system_group*]
#   Run db_sync by this system group.
#   Default: ec2api
#
class ec2api::db::sync (
  $system_user  = 'ec2api',
  $system_group = 'ec2api',
) {

  include ::ec2api::deps

  exec { 'ec2api_db_sync' :
    command     => 'ec2-api-manage db_sync',
    path        => '/usr/bin',
    user        => $system_user,
    group       => $system_group,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['ec2api::install::end'],
      Anchor['ec2api::config::end'],
      Anchor['ec2api::dbsync::begin']
    ],
    notify      => Anchor['ec2api::dbsync::end'],
    tag         => 'openstack-db',
  }

}
