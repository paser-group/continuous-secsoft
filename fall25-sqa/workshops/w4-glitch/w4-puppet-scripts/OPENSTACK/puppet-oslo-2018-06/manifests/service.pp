# == Define: oslo::service
#
# Configure oslo_service options
#
# This resource configures Oslo service resources for an OpenStack service.
# It will manage the [DEFAULT] and [ssl] sections in the given config resource.
#
# === Parameters:
#
# [*api_paste_config*]
#   (optional) File name for the paste.deploy config for api service.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*backdoor_port*]
#   (optional) Enable eventlet backdoor. Acceptable values are 0, <port>, and
#   <start>:<end>, where 0 results in listening on a random tcp port number.
#   Defaults to $::os_service_default.
#
# [*backdoor_socket*]
#   (optional) Enable eventlet backdoor, using the provided path as a unix
#   socket that can receive connections. (string value)
#   Defaults to $::os_service_default.
#
# [*client_socket_timeout*]
#   (optional) Timeout for client connections' socket operations. A value of
#   '0' means wait forever. (integer value)
#   Defaults to $::os_service_default.
#
# [*graceful_shutdown_timeout*]
#   (optional) pecify a timeout after which a gracefully shutdown server will
#   exit. '0' value means endless wait. (integer value)
#   Defaults to $::os_service_default.
#
# [*log_options*]
#   (optional) Enables or disables logging values of all registered options
#   when starting a service (at DEBUG level). (boolean value)
#   Defaults to $::os_service_default.
#
# [*max_header_line*]
#   (optional) Maximum line size of message headers to be accepted.
#   (integer value)
#   Defaults to $::os_service_default.
#
# [*run_external_periodic_tasks*]
#   (optional) Some periodic tasks can be run in a separate process.
#   (boolean value)
#   Defaults to $::os_service_default.
#
# [*tcp_keepidle*]
#   (optional) # Sets the value of TCP_KEEPIDLE in seconds for each server socket.
#   (integer value)
#   Defaults to $::os_service_default.
#
# [*wsgi_default_pool_size*]
#   (optional) Size of the pool of greenthreads used by wsgi (integer value)
#   Defaults to $::os_service_default.
#
# [*wsgi_keep_alive*]
#   (optional) If False, closes the client socket connection explicitly.
#   (boolean value)
#   Defaults to $::os_service_default.
#
# [*wsgi_log_format*]
#   (optional) A python format string that is used as the template to generate
#   log lines. (string value)
#   Defaults to $::os_service_default.
#   Example: '%(client_ip)s "%(request_line)s" status: %(status_code)s len: \
#             %(body_length)s time: %(wall_seconds).7f'
#
# === ssl parameters
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*cert_file*]
#   (optional) Certificate file to use when starting the server securely.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*ciphers*]
#   (optional) Sets the list of available ciphers. value should be a string
#   in the OpenSSL cipher list format. (string value)
#   Defaults to $::os_service_default.
#
# [*key_file*]
#   (optional) Private key file to use when starting the server securely.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*version*]
#   (optional) SSL version to use (valid only if SSL enabled). Valid values are
#   TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may be available on
#   some distributions. (string value)
#   Defaults to $::os_service_default.
#
define oslo::service (
  $api_paste_config            = $::os_service_default,
  $backdoor_port               = $::os_service_default,
  $backdoor_socket             = $::os_service_default,
  $client_socket_timeout       = $::os_service_default,
  $graceful_shutdown_timeout   = $::os_service_default,
  $log_options                 = $::os_service_default,
  $max_header_line             = $::os_service_default,
  $run_external_periodic_tasks = $::os_service_default,
  $tcp_keepidle                = $::os_service_default,
  $wsgi_default_pool_size      = $::os_service_default,
  $wsgi_keep_alive             = $::os_service_default,
  $wsgi_log_format             = $::os_service_default,
  $ca_file                     = $::os_service_default,
  $cert_file                   = $::os_service_default,
  $ciphers                     = $::os_service_default,
  $key_file                    = $::os_service_default,
  $version                     = $::os_service_default,
) {

  $service_options = {
    'DEFAULT/api_paste_config'            => { value => $api_paste_config },
    'DEFAULT/backdoor_port'               => { value => $backdoor_port },
    'DEFAULT/backdoor_socket'             => { value => $backdoor_socket },
    'DEFAULT/client_socket_timeout'       => { value => $client_socket_timeout },
    'DEFAULT/graceful_shutdown_timeout'   => { value => $graceful_shutdown_timeout },
    'DEFAULT/log_options'                 => { value => $log_options },
    'DEFAULT/max_header_line'             => { value => $max_header_line },
    'DEFAULT/run_external_periodic_tasks' => { value => $run_external_periodic_tasks },
    'DEFAULT/tcp_keepidle'                => { value => $tcp_keepidle },
    'DEFAULT/wsgi_default_pool_size'      => { value => $wsgi_default_pool_size },
    'DEFAULT/wsgi_keep_alive'             => { value => $wsgi_keep_alive },
    'DEFAULT/wsgi_log_format'             => { value => $wsgi_log_format },
    'ssl/ca_file'                         => { value => $ca_file },
    'ssl/cert_file'                       => { value => $cert_file },
    'ssl/ciphers'                         => { value => $ciphers },
    'ssl/key_file'                        => { value => $key_file },
    'ssl/version'                         => { value => $version },
  }

  create_resources($name, $service_options)

}
