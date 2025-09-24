# == Class: vitrage::db::postgresql
#
# Class that configures postgresql for vitrage
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'vitrage'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'vitrage'.
#
# [*encoding*]
#   (Optional) The charset to use for the database.
#   Default to undef.
#
# [*privileges*]
#   (Optional) Privileges given to the database user.
#   Default to 'ALL'
#
class vitrage::db::postgresql(
  $password,
  $dbname     = 'vitrage',
  $user       = 'vitrage',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include vitrage::deps

  ::openstacklib::db::postgresql { 'vitrage':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['vitrage::db::begin']
  ~> Class['vitrage::db::postgresql']
  ~> Anchor['vitrage::db::end']

}
