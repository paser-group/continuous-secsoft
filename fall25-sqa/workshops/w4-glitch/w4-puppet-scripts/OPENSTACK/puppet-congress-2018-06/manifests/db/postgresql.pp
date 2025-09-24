# == Class: congress::db::postgresql
#
# Class that configures postgresql for congress
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'congress'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'congress'.
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
class congress::db::postgresql(
  $password,
  $dbname     = 'congress',
  $user       = 'congress',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::congress::deps

  ::openstacklib::db::postgresql { 'congress':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['congress::db::begin']
  ~> Class['congress::db::postgresql']
  ~> Anchor['congress::db::end']

}
