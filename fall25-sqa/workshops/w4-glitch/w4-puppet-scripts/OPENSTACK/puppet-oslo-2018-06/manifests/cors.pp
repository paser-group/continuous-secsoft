# == Define: oslo::cors
#
# Configure oslo_middleware options in cors section
#
# This resource configures oslo.middleware cors resources for an OpenStack
# service. It will manage the [cors]/[cors.$subdomain] section in the given config resource.
#
# === Parameters:
#
# [*allowed_origin*]
#   (Optional) Indicate whether this resource may be shared with the domain
#   received in the requests "origin" header.
#   (string value)
#   Defaults to $::os_service_default.
#
# [*allow_credentials*]
#   (Optional) Indicate that the actual request can include user credentials.
#   (boolean value)
#   Defaults to $::os_service_default.
#
# [*expose_headers*]
#   (Optional) Indicate which headers are safe to expose to the API.
#   (list value)
#   Defaults to $::os_service_default.
#
# [*max_age*]
#   (Optional) Maximum cache age of CORS preflight requests.
#   (integer value)
#   Defaults to $::os_service_default.
#
# [*allow_methods*]
#   (Optional) Indicate which methods can be used during the actual request.
#   (list value)
#   Defaults to $::os_service_default.
#
# [*allow_headers*]
#   (Optional) Indicate which header field names may be used during the actual
#   request.
#   (list value)
#   Defaults to $::os_service_default.
#
define oslo::cors(
  $allowed_origin    = $::os_service_default,
  $allow_credentials = $::os_service_default,
  $expose_headers    = $::os_service_default,
  $max_age           = $::os_service_default,
  $allow_methods     = $::os_service_default,
  $allow_headers     = $::os_service_default,
) {

  $cors_options = {
    'cors/allowed_origin'    => { value => $allowed_origin },
    'cors/allow_credentials' => { value => $allow_credentials },
    'cors/expose_headers'    => { value => $expose_headers },
    'cors/max_age'           => { value => $max_age },
    'cors/allow_methods'     => { value => $allow_methods },
    'cors/allow_headers'     => { value => $allow_headers }
  }
  create_resources($name, $cors_options)
}
