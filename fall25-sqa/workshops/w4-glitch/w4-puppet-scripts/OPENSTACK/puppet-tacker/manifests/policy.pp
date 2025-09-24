# == Class: tacker::policy
#
# Configure the tacker policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for tacker
#   Example :
#     {
#       'tacker-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'tacker-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.json file
#   Defaults to /etc/tacker/policy.json
#
class tacker::policy (
  $policies    = {},
  $policy_path = '/etc/tacker/policy.json',
) {

  include tacker::deps
  include tacker::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::tacker::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'tacker_config': policy_file => $policy_path }

}
