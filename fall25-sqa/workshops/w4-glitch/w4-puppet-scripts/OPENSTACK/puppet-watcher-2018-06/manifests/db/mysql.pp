# The watcher::db::mysql class implements mysql backend for watcher
#
# This class can be used to create tables, users and grant
# privilege for a mysql watcher database.
#
# == parameters
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
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'
#
# [*collate*]
#   (Optional) The database collate.
#   Only used with mysql modules >= 2.2.
#   Defaults to 'utf8_general_ci'
#
# == Dependencies
#   Class['mysql::server']
#
# == Examples
#
# == Authors
#
# == Copyright
#
class watcher::db::mysql(
  $password,
  $dbname        = 'watcher',
  $user          = 'watcher',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef
) {

  include ::watcher::deps

  validate_string($password)

  ::openstacklib::db::mysql { 'watcher':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['watcher::db::begin']
  ~> Class['watcher::db::mysql']
  ~> Anchor['watcher::db::end']

}
