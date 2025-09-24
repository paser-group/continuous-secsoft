# == Class: vitrage::policy
#
# Configure the vitrage policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for vitrage
#   Example :
#     {
#       'vitrage-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'vitrage-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/vitrage/policy.json
#
class vitrage::policy (
  $policies    = {},
  $policy_path = '/etc/vitrage/policy.json',
) {

  include ::vitrage::deps
  include ::vitrage::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::vitrage::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'vitrage_config': policy_file => $policy_path }

}
