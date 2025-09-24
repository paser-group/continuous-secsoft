# == Class: octavia::policy
#
# Configure the octavia policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for octavia
#   Example :
#     {
#       'octavia-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'octavia-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/octavia/policy.json
#
class octavia::policy (
  $policies    = {},
  $policy_path = '/etc/octavia/policy.json',
) {

  include ::octavia::deps
  include ::octavia::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::octavia::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'octavia_config': policy_file => $policy_path }

}
