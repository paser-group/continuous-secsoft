# == Define: oslo::log
#
# Configure oslo_log options
#
# This resource configures Oslo logging resources for an OpenStack service.
# It will manage the [DEFAULT] section in the given config resource.
#
# === Parameters:
#
# [*debug*]
#   (Optional) Should the daemons log debug messages
#   Defaults to $::os_service_default
#
# [*log_config_append*]
#   The name of an additional logging configuration file.
#   Defaults to $::os_service_default
#   See https://docs.python.org/2/howto/logging.html
#
# [*log_date_format*]
#   (Optional) Format string for %%(asctime)s in log records.
#   Defaults to $::os_service_default
#   Example: 'Y-%m-%d %H:%M:%S'
#
# [*log_file*]
#   (Optional) Name of log file to output to. If no default is set, logging will go to stdout.
#   This option is ignored if log_config_append is set.
#   Defaults to $::os_service_default
#
# [*log_dir*]
#   (Optional) Directory where logs should be stored.
#   If set to $::os_service_default, it will not log to any directory.
#   Defaults to $::os_service_default
#
# [*watch_log_file*]
#   (Optional) Uses logging handler designed to watch file system (boolean value).
#   Defaults to $::os_service_default
#
# [*use_syslog*]
#   (Optional) Use syslog for logging (boolean value).
#   Defaults to $::os_service_default
#
# [*use_journal*]
#   (Optional) Use journald for logging (boolean value).
#   Defaults to $::os_service_default
#
# [*syslog_log_facility*]
#   (Optional) Syslog facility to receive log lines.
#   This option is ignored if log_config_append is set.
#   Defaults to $::os_service_default
#
# [*use_json*]
#   (Optional) Use JSON format for logging (boolean value).
#   Defaults to $::os_service_default
#
# [*use_stderr*]
#   (Optional) Log output to standard error.
#   This option is ignored if log_config_append is set.
#   Defaults to $::os_service_default
#
# [*logging_context_format_string*]
#   (Optional) Format string to use for log messages with context.
#   Defaults to $::os_service_default
#   Example: '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s \
#             [%(request_id)s %(user_identity)s] %(instance)s%(message)s'
#
# [*logging_default_format_string*]
#   (Optional) Format string to use for log messages when context is undefined.
#   Defaults to $::os_service_default
#   Example:  '%(asctime)s.%(msecs)03d %(process)d %(levelname)s \
#              %(name)s [-] %(instance)s%(message)s'
#
# [*logging_debug_format_suffix*]
#   (Optional) Additional data to append to log message when logging level for the message is DEBUG'
#   Defaults to $::os_service_default
#   Example: '%(funcName)s %(pathname)s:%(lineno)d'
#
# [*logging_exception_prefix*]
#   (Optional) Prefix each line of exception output with this format.
#   Defaults to $::os_service_default
#   Example: '%(asctime)s.%(msecs)03d %(process)d ERROR %(name)s %(instance)s'
#
# [*logging_user_identity_format*]
#   (Optional) Defines the format string for %(user_identity)s that is used in logging_context_format_string.
#   Defaults to $::os_service_default
#   Example: '%(user)s %(tenant)s %(domain)s %(user_domain)s %(project_domain)s'
#
# [*default_log_levels*]
#   (Optional) Hash of logger (keys) and level (values) pairs.
#   Defaults to $::os_service_default
#   Example:
#     { 'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
#       'sqlalchemy' => 'WARN', 'suds' => 'INFO', 'iso8601' => 'WARN',
#       'requests.packages.urllib3.connectionpool' => 'WARN' }
#
# [*publish_errors*]
#   (Optional) Enables or disables publication of error events (boolean value).
#   Defaults to $::os_service_default
#
# [*instance_format*]
#   (Optional) The format for an instance that is passed with the log message.
#   Defaults to $::os_service_default
#   Example: '[instance: %(uuid)s] '
#
# [*instance_uuid_format*]
#   (Optional) The format for an instance UUID that is passed with the log message.
#   Defaults to $::os_service_default
#   Example: '[instance: %(uuid)s] '
#
# [*fatal_deprecations*]
#   (Optional) Enables or disables fatal status of deprecations (boolean value).
#   Defaults to $::os_service_default
#
define oslo::log(
  $debug                         = $::os_service_default,
  $log_config_append             = $::os_service_default,
  $log_date_format               = $::os_service_default,
  $log_file                      = $::os_service_default,
  $log_dir                       = $::os_service_default,
  $watch_log_file                = $::os_service_default,
  $use_syslog                    = $::os_service_default,
  $use_journal                   = $::os_service_default,
  $use_json                      = $::os_service_default,
  $syslog_log_facility           = $::os_service_default,
  $use_stderr                    = $::os_service_default,
  $logging_context_format_string = $::os_service_default,
  $logging_default_format_string = $::os_service_default,
  $logging_debug_format_suffix   = $::os_service_default,
  $logging_exception_prefix      = $::os_service_default,
  $logging_user_identity_format  = $::os_service_default,
  $default_log_levels            = $::os_service_default,
  $publish_errors                = $::os_service_default,
  $instance_format               = $::os_service_default,
  $instance_uuid_format          = $::os_service_default,
  $fatal_deprecations            = $::os_service_default,
){

  if is_service_default($default_log_levels) {
    $default_log_levels_real = $default_log_levels
  } else {
    validate_hash($default_log_levels)
    $default_log_levels_real = join(sort(join_keys_to_values($default_log_levels, '=')), ',')
  }

  # NOTE(mwhahaha): oslo.log doesn't like it when debug is not a proper python
  # boolean. See LP#1719929
  if !is_service_default($debug) {
    $debug_real = any2bool($debug)
  } else {
    $debug_real = $debug
  }

  $log_options = {
    'DEFAULT/debug'                         => { value => $debug_real },
    'DEFAULT/log_config_append'             => { value => $log_config_append },
    'DEFAULT/log_date_format'               => { value => $log_date_format },
    'DEFAULT/log_file'                      => { value => $log_file },
    'DEFAULT/log_dir'                       => { value => $log_dir },
    'DEFAULT/watch_log_file'                => { value => $watch_log_file },
    'DEFAULT/use_syslog'                    => { value => $use_syslog },
    'DEFAULT/use_journal'                   => { value => $use_journal },
    'DEFAULT/use_json'                      => { value => $use_json },
    'DEFAULT/syslog_log_facility'           => { value => $syslog_log_facility },
    'DEFAULT/use_stderr'                    => { value => $use_stderr },
    'DEFAULT/logging_context_format_string' => { value => $logging_context_format_string },
    'DEFAULT/logging_default_format_string' => { value => $logging_default_format_string },
    'DEFAULT/logging_debug_format_suffix'   => { value => $logging_debug_format_suffix },
    'DEFAULT/logging_exception_prefix'      => { value => $logging_exception_prefix },
    'DEFAULT/logging_user_identity_format'  => { value => $logging_user_identity_format },
    'DEFAULT/default_log_levels'            => { value => $default_log_levels_real },
    'DEFAULT/publish_errors'                => { value => $publish_errors },
    'DEFAULT/instance_format'               => { value => $instance_format },
    'DEFAULT/instance_uuid_format'          => { value => $instance_uuid_format },
    'DEFAULT/fatal_deprecations'            => { value => $fatal_deprecations },
  }

  create_resources($name, $log_options)
}
