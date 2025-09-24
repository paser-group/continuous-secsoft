# == Class: congress::config
#
# This class is used to manage arbitrary congress configurations.
#
# === Parameters
#
# [*congress_config*]
#   (optional) Allow configuration of arbitrary congress configurations.
#   The value is an hash of congress_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   congress_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*congress_api_paste_ini*]
#   (optional) Allow configuration of /etc/congress/api-paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class congress::config (
  $congress_config    = {},
  $congress_api_paste_ini = {},
) {

  include ::congress::deps

  validate_hash($congress_config)
  validate_hash($congress_api_paste_ini)

  create_resources('congress_config', $congress_config)
  create_resources('congress_api_paste_ini', $congress_api_paste_ini)
}
