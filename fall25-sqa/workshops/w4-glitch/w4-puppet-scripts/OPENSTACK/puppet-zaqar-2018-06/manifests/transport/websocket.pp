# == class: zaqar::transport::websocket
#
# [*bind*]
#   Address on which the self-hosting server will listen.
#   Defaults to $::os_service_default.
#
# [*port*]
#   Port on which the self-hosting server will listen.
#   Defaults to $::os_service_default.
#
# [*external_port*]
#   Port on which the service is provided to the user.
#   Defaults to $::os_service_default.
#
# [*notification_bind*]
#   Address on which the notification server will listen.
#   Defaults to $::os_service_default.
#
# [*notification_port*]
#   Port on which the notification server will listen.
#   Defaults to $::os_service_default.
#
class zaqar::transport::websocket(
  $bind               = $::os_service_default,
  $port               = $::os_service_default,
  $external_port      = $::os_service_default,
  $notification_bind  = $::os_service_default,
  $notification_port  = $::os_service_default,
) {

  include ::zaqar::deps

  zaqar_config {
    'drivers:transport:websocket/bind': value => $bind;
    'drivers:transport:websocket/port': value => $port;
    'drivers:transport:websocket/external_port': value => $external_port;
    'drivers:transport:websocket/notification_bind': value => $notification_bind;
    'drivers:transport:websocket/notification_port': value => $notification_port;
  }

}
