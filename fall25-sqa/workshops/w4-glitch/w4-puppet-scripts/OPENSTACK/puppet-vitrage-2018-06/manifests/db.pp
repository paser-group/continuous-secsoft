# == Class: vitrage::db
#
#  Configure the vitrage database
#
# === Parameters
#
# [*database_connection*]
#   (Optional) Url used to connect to database.
#   Defaults to "mysql+pymysql://vitrage:secrete@localhost:3306/vitrage".
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default.
#
# [*database_db_max_retries*]
#   (optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default
#
# [*database_idle_timeout*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to $::os_service_default.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to $::os_service_default.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $::os_service_default.
#
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $::os_service_default
#
class vitrage::db (
  $database_connection     = 'mysql+pymysql://vitrage:secrete@localhost:3306/vitrage',
  $database_idle_timeout   = $::os_service_default,
  $database_min_pool_size  = $::os_service_default,
  $database_max_pool_size  = $::os_service_default,
  $database_db_max_retries = $::os_service_default,
  $database_max_retries    = $::os_service_default,
  $database_retry_interval = $::os_service_default,
  $database_max_overflow   = $::os_service_default,
  $database_pool_timeout   = $::os_service_default,
) {

  include ::vitrage::deps

  $database_connection_real = pick($::vitrage::database_connection, $database_connection)
  $database_idle_timeout_real = pick($::vitrage::database_idle_timeout, $database_idle_timeout)
  $database_min_pool_size_real = pick($::vitrage::database_min_pool_size, $database_min_pool_size)
  $database_max_pool_size_real = pick($::vitrage::database_max_pool_size, $database_max_pool_size)
  $database_max_retries_real = pick($::vitrage::database_max_retries, $database_max_retries)
  $database_retry_interval_real = pick($::vitrage::database_retry_interval, $database_retry_interval)
  $database_max_overflow_real = pick($::vitrage::database_max_overflow, $database_max_overflow)

  validate_re($database_connection_real,
    '^(sqlite|mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

  oslo::db { 'vitrage_config':
    connection     => $database_connection_real,
    idle_timeout   => $database_idle_timeout_real,
    min_pool_size  => $database_min_pool_size_real,
    max_pool_size  => $database_max_pool_size_real,
    db_max_retries => $database_db_max_retries,
    max_retries    => $database_max_retries_real,
    retry_interval => $database_retry_interval_real,
    max_overflow   => $database_max_overflow_real,
    pool_timeout   => $database_pool_timeout,
  }

}
