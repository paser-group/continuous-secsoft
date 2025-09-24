# == Class: zaqar::policy
#
# Configure the zaqar policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for zaqar
#   Example :
#     {
#       'zaqar-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'zaqar-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the zaqar policy.json file
#   Defaults to /etc/zaqar/policy.json
#
class zaqar::policy (
  $policies    = {},
  $policy_path = '/etc/zaqar/policy.json',
) {

  include ::zaqar::deps
  include ::zaqar::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::zaqar::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'zaqar_config': policy_file => $policy_path }

}
