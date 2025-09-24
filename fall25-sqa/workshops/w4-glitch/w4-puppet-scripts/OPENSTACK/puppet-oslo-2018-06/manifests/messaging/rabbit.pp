# == Define: oslo::messaging::rabbit
#
# Configure oslo_messaging_rabbit options
#
# This resource configures Oslo messaging resources for an OpenStack service.
# It manages the [oslo_messaging_rabbit] section in the given config resource.
#
# === Parameters:
#
#  [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq. (boolean value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (Optional) SSL version to use (valid only if SSL enabled). '
#   Valid values are TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1,
#   and TLSv1_2 may be available on some distributions. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (Optional) SSL key file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (Optional) SSL cert file (valid only if SSL enabled). (string value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (Optional) SSL certification authority file (valid only if SSL enabled).
#   (string value)
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
# [*kombu_missing_consumer_retry_timeout*]
#   (Optional) How long to wait a missing client beforce abandoning to send it
#   its replies. This value should not be longer than rpc_response_timeout.
#   (integer value)
#   Defaults to $::os_service_default
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_host*]
#   (Optional) The RabbitMQ broker address where a single node is used.
#   (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_port*]
#   (Optional) The RabbitMQ broker port where a single node is used.
#   (port value)
#   Defaults to $::os_service_default
#
# [*rabbit_qos_prefetch_count*]
#   (Optional) Specifies the number of messages to prefetch
#   Defaults to $::os_service_default
#
# [*rabbit_hosts*]
#   (Optional) RabbitMQ HA cluster host:port pairs. (array value)
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_userid*]
#   (Optional) The RabbitMQ userid. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_password*]
#   (Optional) The RabbitMQ password. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_login_method*]
#   (Optional) The RabbitMQ login method. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_virtual_host*]
#   (Optional) The RabbitMQ virtual host. (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_retry_interval*]
#   (Optional) How frequently to retry connecting with RabbitMQ.
#   (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_retry_backoff*]
#   (Optional) How long to backoff for between retries when connecting
#   to RabbitMQ. (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_interval_max*]
#   (Optional) Maximum interval of RabbitMQ connection retries. (integer value)
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (Optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value)
#   Defaults to $::os_service_default
#
# [*rabbit_transient_queues_ttl*]
#   (Optional) Positive integer representing duration in seconds for
#   queue TTL (x-expires). Queues which are unused for the duration
#   of the TTL are automatically deleted.
#   The parameter affects only reply and fanout queues. (integer value)
#   Min to 1
#   Defaults to $::os_service_default
#
# [*heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $::os_service_default
#
# [*heartbeat_rate*]
#   (Optional) How often times during the heartbeat_timeout_threshold
#   we check the heartbeat. (integer value)
#   Defaults to $::os_service_default
#
define oslo::messaging::rabbit(
  $amqp_durable_queues                  = $::os_service_default,
  $kombu_ssl_version                    = $::os_service_default,
  $kombu_ssl_keyfile                    = $::os_service_default,
  $kombu_ssl_certfile                   = $::os_service_default,
  $kombu_ssl_ca_certs                   = $::os_service_default,
  $kombu_reconnect_delay                = $::os_service_default,
  $kombu_missing_consumer_retry_timeout = $::os_service_default,
  $kombu_failover_strategy              = $::os_service_default,
  $kombu_compression                    = $::os_service_default,
  $rabbit_host                          = $::os_service_default,
  $rabbit_port                          = $::os_service_default,
  $rabbit_qos_prefetch_count            = $::os_service_default,
  $rabbit_hosts                         = $::os_service_default,
  $rabbit_use_ssl                       = $::os_service_default,
  $rabbit_userid                        = $::os_service_default,
  $rabbit_password                      = $::os_service_default,
  $rabbit_login_method                  = $::os_service_default,
  $rabbit_virtual_host                  = $::os_service_default,
  $rabbit_retry_interval                = $::os_service_default,
  $rabbit_retry_backoff                 = $::os_service_default,
  $rabbit_interval_max                  = $::os_service_default,
  $rabbit_ha_queues                     = $::os_service_default,
  $rabbit_transient_queues_ttl          = $::os_service_default,
  $heartbeat_timeout_threshold          = $::os_service_default,
  $heartbeat_rate                       = $::os_service_default,
){

  if $rabbit_use_ssl != true {
    if ! is_service_default($kombu_ssl_ca_certs) and ($kombu_ssl_ca_certs) {
      fail('The kombu_ssl_ca_certs parameter requires rabbit_use_ssl to be set to true')
    }
    if ! is_service_default($kombu_ssl_certfile) and ($kombu_ssl_certfile) {
      fail('The kombu_ssl_certfile parameter requires rabbit_use_ssl to be set to true')
    }
    if ! is_service_default($kombu_ssl_keyfile) and ($kombu_ssl_keyfile) {
      fail('The kombu_ssl_keyfile parameter requires rabbit_use_ssl to be set to true')
    }
    if !is_service_default($kombu_ssl_version) and ($kombu_ssl_version) {
      fail('The kombu_ssl_version parameter requires rabbit_use_ssl to be set to true')
    }
  }

  if !is_service_default($kombu_compression) and !($kombu_compression in ['gzip','bz2']) {
    fail('Unsupported Kombu compression. Possible values are gzip and bz2')
  }

  if !is_service_default($rabbit_hosts) or !is_service_default($rabbit_host) {
    warning("The oslo_messaging rabbit_host, rabbit_hosts, rabbit_port, rabbit_userid, \
rabbit_password, rabbit_virtual_host parameters have been deprecated by the \
[DEFAULT]\\transport_url. Please use oslo::messaging::default::transport_url instead.")
  }

  if !is_service_default($rabbit_hosts) {
    $rabbit_hosts_orig = join(any2array($rabbit_hosts), ',')
    if size($rabbit_hosts) > 1 and is_service_default($rabbit_ha_queues) {
      $rabbit_ha_queues_orig = true
    } else {
      $rabbit_ha_queues_orig = $rabbit_ha_queues
    }
    # Do not set rabbit_port and rabbit_host
    $rabbit_port_orig = $::os_service_default
    $rabbit_host_orig = $::os_service_default
  } else {
    $rabbit_port_orig      = $rabbit_port
    $rabbit_host_orig      = $rabbit_host
    $rabbit_ha_queues_orig = $rabbit_ha_queues
    # Do not set rabbit_hosts if host or port or both are set
    $rabbit_hosts_orig     = $::os_service_default
  }

  $rabbit_options = { 'oslo_messaging_rabbit/amqp_durable_queues' => { value => $amqp_durable_queues },
                      'oslo_messaging_rabbit/heartbeat_rate' => { value => $heartbeat_rate },
                      'oslo_messaging_rabbit/heartbeat_timeout_threshold' => { value => $heartbeat_timeout_threshold },
                      'oslo_messaging_rabbit/kombu_compression' => { value => $kombu_compression },
                      'oslo_messaging_rabbit/kombu_failover_strategy' => { value => $kombu_failover_strategy },
                      'oslo_messaging_rabbit/kombu_missing_consumer_retry_timeout' => { value => $kombu_missing_consumer_retry_timeout },
                      'oslo_messaging_rabbit/kombu_reconnect_delay' => { value => $kombu_reconnect_delay },
                      'oslo_messaging_rabbit/rabbit_interval_max' => { value => $rabbit_interval_max },
                      'oslo_messaging_rabbit/rabbit_login_method' => { value => $rabbit_login_method },
                      'oslo_messaging_rabbit/rabbit_password' => { value => $rabbit_password, secret => true },
                      'oslo_messaging_rabbit/rabbit_retry_backoff' => { value => $rabbit_retry_backoff },
                      'oslo_messaging_rabbit/rabbit_retry_interval' => { value => $rabbit_retry_interval },
                      'oslo_messaging_rabbit/rabbit_transient_queues_ttl' => { value => $rabbit_transient_queues_ttl },
                      'oslo_messaging_rabbit/ssl' => { value => $rabbit_use_ssl },
                      'oslo_messaging_rabbit/rabbit_userid' => { value => $rabbit_userid },
                      'oslo_messaging_rabbit/rabbit_virtual_host' => { value => $rabbit_virtual_host },
                      'oslo_messaging_rabbit/rabbit_hosts' => { value => $rabbit_hosts_orig },
                      'oslo_messaging_rabbit/rabbit_port' => { value => $rabbit_port_orig },
                      'oslo_messaging_rabbit/rabbit_qos_prefetch_count' => { value => $rabbit_qos_prefetch_count },
                      'oslo_messaging_rabbit/rabbit_host' => { value => $rabbit_host_orig },
                      'oslo_messaging_rabbit/rabbit_ha_queues' => { value => $rabbit_ha_queues_orig },
                      'oslo_messaging_rabbit/ssl_ca_file' => { value => $kombu_ssl_ca_certs },
                      'oslo_messaging_rabbit/ssl_cert_file' => { value => $kombu_ssl_certfile },
                      'oslo_messaging_rabbit/ssl_key_file' => { value => $kombu_ssl_keyfile },
                      'oslo_messaging_rabbit/ssl_version' => { value => $kombu_ssl_version },
                    }

  create_resources($name, $rabbit_options)
}
