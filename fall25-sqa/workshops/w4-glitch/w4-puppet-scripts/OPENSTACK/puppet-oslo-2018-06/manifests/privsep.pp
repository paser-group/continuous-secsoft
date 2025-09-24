# == Define: oslo::privsep
#
# Configure oslo_privsep options
#
# This resource configures Oslo privilege separator resources for an OpenStack service.
# It will manage the [privsep_${entrypoint}] section in the given config resource.
#
# === Parameters:
#
# [*entrypoint*]
#  (Required) Privsep entrypoint. (string value)
#  Defaults to $name.
#
# [*config*]
#  (Required) Configuration file to manage. (string value)
#
# [*user*]
#  (Optional) User that the privsep daemon should run as. (string value)
#  Defaults to $::os_service_default.
#
# [*group*]
#  (Optional) Group that the privsep daemon should run as. (string value)
#  Defaults to $::os_service_default.
#
# [*capabilities*]
#  (Optional) List of Linux capabilities retained by the privsep daemon. (list value)
#  Defaults to $::os_service_default.
#
# [*helper_command*]
#  (Optional) Command to invoke to start the privsep daemon if not using the "fork" method.
#  If not specified, a default is generated using "sudo privsep-helper" and arguments designed to
#  recreate the current configuration. This command must accept suitable --privsep_context
#  and --privsep_sock_path arguments.
#  Defaults to $::os_service_default.
#
# == Examples
#
#   oslo::privsep { 'osbrick':
#     config => 'nova_config'
#   }
#
define oslo::privsep (
  $config,
  $entrypoint     = $name,
  $user           = $::os_service_default,
  $group          = $::os_service_default,
  $capabilities   = $::os_service_default,
  $helper_command = $::os_service_default,
) {

  $privsep_options = {
    "privsep_${entrypoint}/user"           => { value => $user },
    "privsep_${entrypoint}/group"          => { value => $group },
    "privsep_${entrypoint}/capabilities"   => { value => $capabilities },
    "privsep_${entrypoint}/helper_command" => { value => $helper_command },
  }

  create_resources($config, $privsep_options)
}
