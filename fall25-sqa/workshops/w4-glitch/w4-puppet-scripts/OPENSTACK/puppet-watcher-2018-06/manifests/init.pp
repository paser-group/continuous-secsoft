# == Class: watcher
#
# Full description of class watcher here.
#
# === Parameters:
#
# [*use_ssl*]
#   (required) Enable SSL on the API server.
#   Defaults to false.
#
# [*ceilometer_client_api_version*]
#   (required) Version of Ceilometer API to use in ceilometerclient.
#   Default is 2.
#
# [*cinder_client_api_version*]
#   (required) Version of Cinder API to use in cinderclient.
#   Default is 2.
#
# [*glance_client_api_version*]
#   (required) Version of Glance API to use in glanceclient.
#   Default is 2.
#
# [*neutron_client_api_version*]
#   (required) Version of Neutron API to use in neutronclient.
#   Default is 2.
#
# [*nova_client_api_version*]
#   (required) Version of Nova API to use in novaclient.
#   Default is 2.
#
# [*package_ensure*]
#  (optional) Whether the watcher api package will be installed
#  Defaults to 'present'
#
# [*rabbit_login_method*]
#   (optional) The RabbitMQ login method. (string value)
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
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ.
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) ow often times during the heartbeat_timeout_threshold we
#   check the heartbeat.
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database.
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
# [*rabbit_heartbeat_timeout_threshold*]
#   (Optional) Number of seconds after which the Rabbit broker is
#   considered down if heartbeat's keep-alive fails
#   (0 disable the heartbeat). EXPERIMENTAL. (integer value)
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled). Valid values are
#   TLSv1 and SSLv23. SSLv2, SSLv3, TLSv1_1, and TLSv1_2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $::os_service_default
#
# [*kombu_missing_consumer_retry_timeout*]
#  (optional)How long to wait a missing client beforce abandoning to send it
#   its replies. This value should not be longer than rpc_response_timeout.
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
# [*amqp_durable_queues*]
#   (optional) Use durable queues in AMQP.
#   Defaults to $::os_service_default
#
# [*default_transport_url*]
#   (Optional) A URL representing the messaging driver to use and its full
#   configuration. If not set, we fall back to the rpc_backend option
#   and driver specific configuration.
#   Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication.
#   Defaults to $::os_service_default
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication.
#   Defaults to $::os_service_default
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate.
#   Defaults to $::os_service_default
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate.
#   Defaults to $::os_service_default
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container.
#   Defaults to $::os_service_default
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms.
#   Defaults to $::os_service_default
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server.
#   Defaults to $::os_service_default
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted).
#   Defaults to $::os_service_default
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections (in seconds).
#   Defaults to $::os_service_default
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients.
#   Defaults to $::os_service_default
#
# [*amqp_broadcast_prefix*]
#   (Optional) Address prefix used when broadcasting to all servers.
#   Defaults to $::os_service_default
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout.
#   Defaults to $::os_service_default
#
# [*amqp_allow_insecure_clients*]
#   (Optional) Accept clients using either SSL or plain TCP.
#   Defaults to $::os_service_default
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix).
#   Defaults to $::os_service_default
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration.
#   Defaults to $::os_service_default
#
# [*amqp_group_request_prefix*]
#   (Optional) Address prefix when sending to any server in group.
#   Defaults to $::os_service_default
#
# [*rpc_cast_timeout*]
#  (optional) Seconds to wait before a cast expires (TTL).
#  The default value of -1 specifies an infinite linger
#  period. The value of 0 specifies no linger period.
#  Pending messages shall be discarded immediately
#  when the socket is closed. Only supported by impl_zmq.
#  Defaults to $::os_service_default.
#
# [*rpc_poll_timeout*]
#  (optional) The default number of seconds that poll should wait.
#  Poll raises timeout exception when timeout expired.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_bind_address*]
#  (optional) ZeroMQ bind address.
#  Should be a wildcard (*), an ethernet interface, or IP.
#  The "host" option should point or resolve to this address.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_bind_port_retries*]
#  (optional) Number of retries to find free port number
#  before fail with ZMQBindError.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_concurrency*]
#  (optional) Type of concurrency used.
#  Either "native" or "eventlet".
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_contexts*]
#  (optional) Number of ZeroMQ contexts.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_host*]
#  (optional) Name of this node.
#  Must be a valid hostname, FQDN, or IP address.
#  Must match "host" option, if running Nova.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_ipc_dir*]
#  (optional) Directory for holding IPC sockets.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_matchmaker*]
#  (optional) MatchMaker driver.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_max_port*]
#  (optional) Maximal port number for random ports range.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_min_port*]
#  (optional) Minimal port number for random ports range.
#  Defaults to $::os_service_default.
#
# [*rpc_zmq_topic_backlog*]
#  (optional) Maximum number of ingress messages to locally buffer per topic.
#  Defaults to $::os_service_default.
#
# [*use_pub_sub*]
#  (optional) Use PUB/SUB pattern for fanout methods.
#  PUB/SUB always uses proxy.
#  Defaults to $::os_service_default.
#
# [*zmq_target_expire*]
#  (optional) Expiration timeout in seconds of a name service
#  record about existing target ( < 0 means no timeout).
#  Defaults to $::os_service_default.
#
# [*notification_transport_url*]
#  (optional) A URL representing the messaging driver to use for notifications
#  and its full configuration. Transport URLs take the form:
#    transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $::os_service_default
#
# [*notification_driver*]
#  (optional) Driver or drivers to handle sending notifications.
#  Value can be a string or a list.
#  Defaults to $::os_service_default
#
# [*notification_topics*]
#  (optional) AMQP topic used for OpenStack notifications
#  Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the watcher config.
#   Defaults to false.
#
# === Authors
#
# Daniel Pawlik  <daniel.pawlik@corp.ovh.com>
#
class watcher (
  $purge_config                         = false,
  $use_ssl                              = false,
  $ceilometer_client_api_version        = '2',
  $cinder_client_api_version            = '2',
  $glance_client_api_version            = '2',
  $neutron_client_api_version           = '2',
  $nova_client_api_version              = '2',
  $package_ensure                       = 'present',
  $rabbit_login_method                  = $::os_service_default,
  $rabbit_retry_interval                = $::os_service_default,
  $rabbit_retry_backoff                 = $::os_service_default,
  $rabbit_interval_max                  = $::os_service_default,
  $rabbit_use_ssl                       = $::os_service_default,
  $rabbit_heartbeat_rate                = $::os_service_default,
  $rabbit_ha_queues                     = $::os_service_default,
  $rabbit_transient_queues_ttl          = $::os_service_default,
  $rabbit_heartbeat_timeout_threshold   = $::os_service_default,
  $kombu_ssl_ca_certs                   = $::os_service_default,
  $kombu_ssl_certfile                   = $::os_service_default,
  $kombu_ssl_keyfile                    = $::os_service_default,
  $kombu_ssl_version                    = $::os_service_default,
  $kombu_reconnect_delay                = $::os_service_default,
  $kombu_missing_consumer_retry_timeout = $::os_service_default,
  $kombu_failover_strategy              = $::os_service_default,
  $kombu_compression                    = $::os_service_default,
  $amqp_durable_queues                  = $::os_service_default,
  $default_transport_url                = $::os_service_default,
  $rpc_response_timeout                 = $::os_service_default,
  $control_exchange                     = $::os_service_default,
  # amqp
  $amqp_username                        = $::os_service_default,
  $amqp_password                        = $::os_service_default,
  $amqp_ssl_ca_file                     = $::os_service_default,
  $amqp_ssl_key_file                    = $::os_service_default,
  $amqp_container_name                  = $::os_service_default,
  $amqp_sasl_mechanisms                 = $::os_service_default,
  $amqp_server_request_prefix           = $::os_service_default,
  $amqp_ssl_key_password                = $::os_service_default,
  $amqp_idle_timeout                    = $::os_service_default,
  $amqp_ssl_cert_file                   = $::os_service_default,
  $amqp_broadcast_prefix                = $::os_service_default,
  $amqp_trace                           = $::os_service_default,
  $amqp_allow_insecure_clients          = $::os_service_default,
  $amqp_sasl_config_name                = $::os_service_default,
  $amqp_sasl_config_dir                 = $::os_service_default,
  $amqp_group_request_prefix            = $::os_service_default,
  # zmq
  $rpc_cast_timeout                     = $::os_service_default,
  $rpc_poll_timeout                     = $::os_service_default,
  $rpc_zmq_bind_address                 = $::os_service_default,
  $rpc_zmq_bind_port_retries            = $::os_service_default,
  $rpc_zmq_concurrency                  = $::os_service_default,
  $rpc_zmq_contexts                     = $::os_service_default,
  $rpc_zmq_host                         = $::os_service_default,
  $rpc_zmq_ipc_dir                      = $::os_service_default,
  $rpc_zmq_matchmaker                   = $::os_service_default,
  $rpc_zmq_max_port                     = $::os_service_default,
  $rpc_zmq_min_port                     = $::os_service_default,
  $rpc_zmq_topic_backlog                = $::os_service_default,
  $use_pub_sub                          = $::os_service_default,
  $zmq_target_expire                    = $::os_service_default,
  # messaging
  $notification_transport_url           = $::os_service_default,
  $notification_driver                  = $::os_service_default,
  $notification_topics                  = $::os_service_default,
) {

  include ::openstacklib::openstackclient

  include ::watcher::deps
  include ::watcher::params
  include ::watcher::policy
  include ::watcher::db
  include ::watcher::logging

  package { 'watcher':
    ensure => $package_ensure,
    name   => $::watcher::params::common_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  resources { 'watcher_config':
    purge  => $purge_config,
  }

  watcher_config {
    'ceilometer_client/api_version': value => $ceilometer_client_api_version;
    'cinder_client/api_version':     value => $cinder_client_api_version;
    'glance_client/api_version':     value => $glance_client_api_version;
    'neutron_client/api_version':    value => $neutron_client_api_version;
    'nova_client/api_version':       value => $nova_client_api_version;
  }

  oslo::messaging::rabbit { 'watcher_config':
    amqp_durable_queues                  => $amqp_durable_queues,
    kombu_ssl_version                    => $kombu_ssl_version,
    kombu_ssl_keyfile                    => $kombu_ssl_keyfile,
    kombu_ssl_certfile                   => $kombu_ssl_certfile,
    kombu_ssl_ca_certs                   => $kombu_ssl_ca_certs,
    kombu_reconnect_delay                => $kombu_reconnect_delay,
    kombu_missing_consumer_retry_timeout => $kombu_missing_consumer_retry_timeout,
    kombu_failover_strategy              => $kombu_failover_strategy,
    kombu_compression                    => $kombu_compression,
    rabbit_use_ssl                       => $rabbit_use_ssl,
    rabbit_login_method                  => $rabbit_login_method,
    rabbit_retry_interval                => $rabbit_retry_interval,
    rabbit_retry_backoff                 => $rabbit_retry_backoff,
    rabbit_interval_max                  => $rabbit_interval_max,
    rabbit_ha_queues                     => $rabbit_ha_queues,
    rabbit_transient_queues_ttl          => $rabbit_transient_queues_ttl,
    heartbeat_timeout_threshold          => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate                       => $rabbit_heartbeat_rate,
  }

  oslo::messaging::amqp { 'watcher_config':
    username               => $amqp_username,
    password               => $amqp_password,
    server_request_prefix  => $amqp_server_request_prefix,
    broadcast_prefix       => $amqp_broadcast_prefix,
    group_request_prefix   => $amqp_group_request_prefix,
    container_name         => $amqp_container_name,
    idle_timeout           => $amqp_idle_timeout,
    trace                  => $amqp_trace,
    ssl_ca_file            => $amqp_ssl_ca_file,
    ssl_cert_file          => $amqp_ssl_cert_file,
    ssl_key_file           => $amqp_ssl_key_file,
    ssl_key_password       => $amqp_ssl_key_password,
    allow_insecure_clients => $amqp_allow_insecure_clients,
    sasl_mechanisms        => $amqp_sasl_mechanisms,
    sasl_config_dir        => $amqp_sasl_config_dir,
    sasl_config_name       => $amqp_sasl_config_name,
  }

  oslo::messaging::zmq { 'watcher_config':
    rpc_cast_timeout          => $rpc_cast_timeout,
    rpc_poll_timeout          => $rpc_poll_timeout,
    rpc_zmq_bind_address      => $rpc_zmq_bind_address,
    rpc_zmq_bind_port_retries => $rpc_zmq_bind_port_retries,
    rpc_zmq_concurrency       => $rpc_zmq_concurrency,
    rpc_zmq_contexts          => $rpc_zmq_contexts,
    rpc_zmq_host              => $rpc_zmq_host,
    rpc_zmq_ipc_dir           => $rpc_zmq_ipc_dir,
    rpc_zmq_matchmaker        => $rpc_zmq_matchmaker,
    rpc_zmq_max_port          => $rpc_zmq_max_port,
    rpc_zmq_min_port          => $rpc_zmq_min_port,
    rpc_zmq_topic_backlog     => $rpc_zmq_topic_backlog,
    use_pub_sub               => $use_pub_sub,
    zmq_target_expire         => $zmq_target_expire,
  }

  oslo::messaging::default { 'watcher_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'watcher_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }
}

