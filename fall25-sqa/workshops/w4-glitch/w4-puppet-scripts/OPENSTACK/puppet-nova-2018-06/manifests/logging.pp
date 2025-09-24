# Class nova::logging
#
#  nova logging configuration
#
# == parameters
#
#  [*debug*]
#    (Optional) Should the daemons log debug messages
#    Defaults to $::os_service_default
#
#  [*use_syslog*]
#    (Optional) Use syslog for logging.
#    Defaults to $::os_service_default
#
#  [*use_json*]
#    (Optional) Use json for logging.
#    Defaults to $::os_service_default
#
#  [*use_journal*]
#    (Optional) Use journal for logging.
#    Defaults to $::os_service_default
#
#  [*use_stderr*]
#    (optional) Use stderr for logging
#    Defaults to $::os_service_default
#
#  [*log_facility*]
#    (Optional) Syslog facility to receive log lines.
#    Defaults to $::os_service_default
#
#  [*log_dir*]
#    (optional) Directory where logs should be stored.
#    If set to $::os_service_default, it will not log to any directory.
#    Defaults to '/var/log/nova'
#
#  [*logging_context_format_string*]
#    (optional) Format string to use for log messages with context.
#    Defaults to $::os_service_default
#    Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s\
#              [%(request_id)s %(user_identity)s] %(instance)s%(message)s'
#
#  [*logging_default_format_string*]
#    (optional) Format string to use for log messages without context.
#    Defaults to $::os_service_default
#    Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s\
#              [-] %(instance)s%(message)s'
#
#  [*logging_debug_format_suffix*]
#    (optional) Formatted data to append to log format when level is DEBUG.
#    Defaults to $::os_service_default
#    Example: '%(funcName)s %(pathname)s:%(lineno)d'
#
#  [*logging_exception_prefix*]
#    (optional) Prefix each line of exception output with this format.
#    Defaults to $::os_service_default
#    Example: '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s'
#
#  [*log_config_append*]
#    The name of an additional logging configuration file.
#    Defaults to $::os_service_default
#    See https://docs.python.org/2/howto/logging.html
#
#  [*default_log_levels*]
#    (optional) Hash of logger (keys) and level (values) pairs.
#    Defaults to $::os_service_default
#    Example:
#      { 'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
#        'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
#        'requests.packages.urllib3.connectionpool' => 'WARN' }
#
#  [*publish_errors*]
#    (optional) Publish error events (boolean value).
#    Defaults to $::os_service_default
#
#  [*fatal_deprecations*]
#    (optional) Make deprecations fatal (boolean value)
#    Defaults to $::os_service_default
#
#  [*instance_format*]
#    (optional) If an instance is passed with the log message, format it
#               like this (string value).
#    Defaults to $::os_service_default
#    Example: '[instance: %(uuid)s] '
#
#  [*instance_uuid_format*]
#    (optional) If an instance UUID is passed with the log message, format
#               it like this (string value).
#    Defaults to $::os_service_default
#    Example: instance_uuid_format='[instance: %(uuid)s] '
#
#  [*log_date_format*]
#    (optional) Format string for %%(asctime)s in log records.
#    Defaults to $::os_service_default
#    Example: 'Y-%m-%d %H:%M:%S'
#
class nova::logging(
  $use_syslog                    = $::os_service_default,
  $use_json                      = $::os_service_default,
  $use_journal                   = $::os_service_default,
  $use_stderr                    = $::os_service_default,
  $log_facility                  = $::os_service_default,
  $log_dir                       = '/var/log/nova',
  $debug                         = $::os_service_default,
  $logging_context_format_string = $::os_service_default,
  $logging_default_format_string = $::os_service_default,
  $logging_debug_format_suffix   = $::os_service_default,
  $logging_exception_prefix      = $::os_service_default,
  $log_config_append             = $::os_service_default,
  $default_log_levels            = $::os_service_default,
  $publish_errors                = $::os_service_default,
  $fatal_deprecations            = $::os_service_default,
  $instance_format               = $::os_service_default,
  $instance_uuid_format          = $::os_service_default,
  $log_date_format               = $::os_service_default,
) {

  include ::nova::deps
  include ::nova::params

  # NOTE(spredzy): In order to keep backward compatibility we rely on the pick function
  # to use nova::<myparam> first then nova::logging::<myparam>.
  $use_syslog_real = pick($::nova::use_syslog,$use_syslog)
  $use_stderr_real = pick($::nova::use_stderr,$use_stderr)
  $log_facility_real = pick($::nova::log_facility,$log_facility)
  if $log_dir != '' {
    $log_dir_real = pick($::nova::log_dir,$log_dir)
  } else {
    $log_dir_real = $log_dir
  }
  $debug_real = pick($::nova::debug,$debug)

  if $log_dir_real != $::os_service_default {
    # TODO: can probably remove this in Rocky once we've had it for 1 upgrade cycle
    # Ensure ownership/permissions for any existing logfiles are correct before configuring nova
    # This matches the rpm/deb logic:
    #    Ubuntu: /var/log/nova is nova:adm
    #    CentOS: /var/log/nova is nova:root
    #    Both: /var/log/nova/*.log is nova:nova
    $log_dir_owner = $::nova::params::nova_user
    $log_dir_group = $::nova::params::nova_log_group
    $log_file_owner = $::nova::params::nova_user
    $log_file_group = $::nova::params::nova_group

    file { $log_dir_real:
      ensure  => directory,
      owner   => $log_dir_owner,
      group   => $log_dir_group,
      require => Anchor['nova::install::end'],
      before  => Anchor['nova::config::begin']
    }

    # Can't tell File[$log_dir_real] to use a different user/group when recursing so resort to chown
    exec { 'chown nova logfiles':
      command => "chown ${log_file_owner}:${log_file_group} ${log_dir_real}/*.log",
      onlyif  => "test \"\$(stat -c '%U:%G' ${log_dir_real}/*.log | grep -v '${log_file_owner}:${log_file_group}')\" != ''",
      path    => ['/usr/bin', '/bin'],
      require => File[$log_dir_real],
      before  => Anchor['nova::config::begin']
    }

    # END TODO, the following resource is likely to be necessary in Rocky and later

    # This should force an update the selinux role if the logfile exists.
    # It will be incorrect if the file was created by the dbsync exec resources.
    file { "${log_dir_real}/nova-manage.log":
      owner   => $log_file_owner,
      group   => $log_file_group,
      require => Anchor['nova::service::end']
    }
  }

  oslo::log { 'nova_config':
    debug                         => $debug_real,
    use_stderr                    => $use_stderr_real,
    use_syslog                    => $use_syslog_real,
    use_json                      => $use_json,
    use_journal                   => $use_journal,
    log_dir                       => $log_dir_real,
    syslog_log_facility           => $log_facility_real,
    logging_context_format_string => $logging_context_format_string,
    logging_default_format_string => $logging_default_format_string,
    logging_debug_format_suffix   => $logging_debug_format_suffix,
    logging_exception_prefix      => $logging_exception_prefix,
    log_config_append             => $log_config_append,
    default_log_levels            => $default_log_levels,
    publish_errors                => $publish_errors,
    fatal_deprecations            => $fatal_deprecations,
    instance_format               => $instance_format,
    instance_uuid_format          => $instance_uuid_format,
    log_date_format               => $log_date_format,
  }

}
