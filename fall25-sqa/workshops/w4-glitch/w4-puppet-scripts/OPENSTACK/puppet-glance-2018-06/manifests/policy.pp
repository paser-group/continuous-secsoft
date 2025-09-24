# == Class: glance::policy
#
# Configure the glance policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for glance
#   Example :
#     {
#       'glance-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'glance-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the glance policy.json file
#   Defaults to /etc/glance/policy.json
#
class glance::policy (
  $policies    = {},
  $policy_path = '/etc/glance/policy.json',
) {

  include ::glance::deps
  include ::glance::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::glance::params::group,
    require    => Anchor['glance::config::begin'],
    notify     => Anchor['glance::config::end'],
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { ['glance_api_config', 'glance_registry_config']: policy_file => $policy_path }

}
