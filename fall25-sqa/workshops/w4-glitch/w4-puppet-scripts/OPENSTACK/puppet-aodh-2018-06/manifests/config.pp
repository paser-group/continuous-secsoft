# == Class: aodh::config
#
# This class is used to manage arbitrary aodh configurations.
#
# === Parameters
#
# [*aodh_config*]
#   (optional) Allow configuration of arbitrary aodh configurations.
#   The value is an hash of aodh_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   aodh_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*aodh_api_paste_ini*]
#   (optional) Allow configuration of /etc/aodh/api-paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class aodh::config (
  $aodh_config        = {},
  $aodh_api_paste_ini = {},
) {

  include ::aodh::deps

  validate_hash($aodh_config)
  validate_hash($aodh_api_paste_ini)

  create_resources('aodh_config', $aodh_config)
  create_resources('aodh_api_paste_ini', $aodh_api_paste_ini)
}
