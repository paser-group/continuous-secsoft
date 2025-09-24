# == Class: rally::db::postgresql
#
# Class that configures postgresql for rally
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'rally'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'rally'.
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
class rally::db::postgresql(
  $password,
  $dbname     = 'rally',
  $user       = 'rally',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::rally::deps

  ::openstacklib::db::postgresql { 'rally':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['rally::db::begin']
  ~> Class['rally::db::postgresql']
  ~> Anchor['rally::db::end']

}
