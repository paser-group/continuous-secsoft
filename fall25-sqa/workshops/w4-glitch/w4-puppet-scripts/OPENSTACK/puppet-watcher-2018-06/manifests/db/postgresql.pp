# == Class: watcher::db::postgresql
#
# Class that configures postgresql for watcher
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'watcher'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'watcher'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class watcher::db::postgresql(
  $password,
  $dbname     = 'watcher',
  $user       = 'watcher',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::watcher::deps

  ::openstacklib::db::postgresql { 'watcher':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['watcher::db::begin']
  ~> Class['watcher::db::postgresql']
  ~> Anchor['watcher::db::end']

}
