# == Define: oslo::policy
#
# Configure oslo_policy options
#
# This resource configures Oslo policy resources for an OpenStack service.
# It will manage the [oslo_policy] section in the given config resource.
#
# === Parameters:
#
# [*policy_file*]
#  (Optional) The JSON file that defines policies. (string value)
#  Defaults to $::os_service_default.
#
# [*policy_default_rule*]
#  (Optional) Default rule. Enforced when a requested rule is not found.
#  (string value)
#  Defaults to $::os_service_default.
#
# [*policy_dirs*]
#  (Optional) Directories where policy configuration files are stored.
#  They can be relative to any directory in the search path defined by
#  the config_dir option, or absolute paths.
#  The file defined by policy_file must exist for these directories to be searched.
#  Missing or empty directories are ignored. (list value)
#  Defaults to $::os_service_default.
#
define oslo::policy(
  $policy_file         = $::os_service_default,
  $policy_default_rule = $::os_service_default,
  $policy_dirs         = $::os_service_default,
) {
  if !is_service_default($policy_dirs) {
    $policy_dirs_orig = join(any2array($policy_dirs), ',')
  } else {
    $policy_dirs_orig = $policy_dirs
  }

  $policy_options = {
    'oslo_policy/policy_file'         => { value => $policy_file },
    'oslo_policy/policy_default_rule' => { value => $policy_default_rule },
    'oslo_policy/policy_dirs'         => { value => $policy_dirs_orig },
  }

  create_resources($name, $policy_options)
}
