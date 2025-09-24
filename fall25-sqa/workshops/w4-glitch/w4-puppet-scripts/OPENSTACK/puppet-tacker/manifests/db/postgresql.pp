# == Class: tacker::db::postgresql
#
# Class that configures postgresql for tacker
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'tacker'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'tacker'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class tacker::db::postgresql(
  $password,
  $dbname     = 'tacker',
  $user       = 'tacker',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include tacker::deps

  ::openstacklib::db::postgresql { 'tacker':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['tacker::db::begin']
  ~> Class['tacker::db::postgresql']
  ~> Anchor['tacker::db::end']

}
