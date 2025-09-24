# == Define: oslo::concurrency
#
# Configure oslo_concurrency options
#
# This resource configures Oslo concurrency resources for an OpenStack service.
# It will manage the [oslo_concurrency] section in the given config resource.
#
# === Parameters:
#
# [*disable_process_locking*]
#  (Optional) Enables or disables inter-process locks. (boolean value)
#  Defaults to $::os_service_default.
#
# [*lock_path*]
#  (Optional) Directory to use for lock files. For security, the specified directory
#  should only be writable by the user running the processes that need locking.
#  If external locks are used, a lock path must be set. (string value)
#  Defaults to $::os_service_default.
#
define oslo::concurrency(
  $disable_process_locking = $::os_service_default,
  $lock_path               = $::os_service_default,
) {
  $concurrency_options = {
    'oslo_concurrency/disable_process_locking' => { value => $disable_process_locking },
    'oslo_concurrency/lock_path'               => { value => $lock_path }
  }

  create_resources($name, $concurrency_options)
}
