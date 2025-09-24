# == Class: magnum::policy
#
# Configure the magnum policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for magnum
#   Example :
#     {
#       'magnum-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'magnum-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/magnum/policy.json
#
class magnum::policy (
  $policies    = {},
  $policy_path = '/etc/magnum/policy.json',
) {

  include ::magnum::deps
  include ::magnum::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::magnum::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'magnum_config': policy_file => $policy_path }

}
