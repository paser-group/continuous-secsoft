# == Define: oslo::messaging::default
#
# Configure oslo DEFAULT messaging options
#
# It will manage the [DEFAULT] section in the given config resource.
#
# === Parameters:
#
# [*rpc_response_timeout*]
#   (Optional) Seconds to wait for a response from a call. (integer value)
#   Defaults to $::os_service_default.
#
# [*transport_url*]
#   (Optional) A URL representing the messaging driver to use
#   and its full configuration. If not set, we fall back to
#   the rpc_backend option and driver specific configuration.
#   Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   (string value)
#   Defaults to $::os_service_default.
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped.
#   May be overridden by an exchange name specified in the transport_url option.
#   (string value)
#   Defaults to $::os_service_default.
#

define oslo::messaging::default(
  $rpc_response_timeout = $::os_service_default,
  $transport_url        = $::os_service_default,
  $control_exchange     = $::os_service_default,
) {

  $default_options = {
    'DEFAULT/rpc_response_timeout' => { value => $rpc_response_timeout },
    'DEFAULT/transport_url'        => { value => $transport_url, secret => true },
    'DEFAULT/control_exchange'     => { value => $control_exchange },
  }

  create_resources($name, $default_options)
}
