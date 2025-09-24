# == Class: rally::db
#
#  Configure the rally database
#
# === Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to "sqlite:////var/lib/rally/rally.sqlite".
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_retries*]
#   Maximum number of database connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to $::os_service_default
#
# [*database_retry_interval*]
#   Interval between retries of opening a database connection.
#   (Optional) Defaults to $::os_service_default
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to $::os_service_default
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to $::os_service_default
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $::os_service_default
#
# [*database_db_max_retries*]
#   (Optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default
#
class rally::db (
  $database_connection     = 'sqlite:////var/lib/rally/rally.sqlite',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
  $database_pool_timeout   = $::os_service_default,
  $database_db_max_retries = $::os_service_default,
) {

  include ::rally::deps

  $database_connection_real = pick($::rally::database_connection, $database_connection)
  $database_idle_timeout_real = pick($::rally::database_idle_timeout, $database_idle_timeout)
  $database_min_pool_size_real = pick($::rally::database_min_pool_size, $database_min_pool_size)
  $database_max_pool_size_real = pick($::rally::database_max_pool_size, $database_max_pool_size)
  $database_max_retries_real = pick($::rally::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::rally::database_retry_interval, $database_retry_interval)
  $database_max_overflow_real = pick($::rally::database_max_overflow, $database_max_overflow)

  validate_re($database_connection_real,
    '(sqlite|mysql|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  # This is only for rally SQLite
  if $database_connection_real =~ /^sqlite:\/\// {
    $sqlite_dir = regsubst($database_connection_real,'^sqlite:\/\/\/(\S+)+\/(\S+)$','\1')
    ensure_resource('file', $sqlite_dir,{
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755',
    })
  }

  oslo::db { 'rally_config':
    connection     => $database_connection_real,
    idle_timeout   => $database_idle_timeout_real,
    min_pool_size  => $database_min_pool_size_real,
    max_pool_size  => $database_max_pool_size_real,
    max_retries    => $database_max_retries_real,
    retry_interval => $database_retry_interval_real,
    max_overflow   => $database_max_overflow_real,
    pool_timeout   => $database_pool_timeout,
    db_max_retries => $database_db_max_retries,
  }

}
