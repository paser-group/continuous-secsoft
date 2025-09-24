# == class: zaqar::messaging::redis
#
# [*uri*]
#   Redis Connection URI. Required.
#
# [*max_reconnect_attempts*]
#   Maximum number of times to retry an operation that failed due to a
#   primary node failover. (integer value)
#   Defaults to $::os_service_default.
#
# [*reconnect_sleep*]
#   Base sleep interval between attempts to reconnect after a primary
#   node failover. The actual sleep time increases exponentially (power
#   of 2) each time the operation is retried. (floating point value)
#   Defaults to $::os_service_default.
#
class zaqar::messaging::redis(
  $uri,
  $max_reconnect_attempts = $::os_service_default,
  $reconnect_sleep        = $::os_service_default,
) {

  include ::zaqar::deps

  zaqar_config {
    'drivers:message_store:redis/uri':                    value => $uri, secret => true;
    'drivers:message_store:redis/max_reconnect_attempts': value => $max_reconnect_attempts;
    'drivers:message_store:redis/reconnect_sleep':        value => $reconnect_sleep;
  }

}
