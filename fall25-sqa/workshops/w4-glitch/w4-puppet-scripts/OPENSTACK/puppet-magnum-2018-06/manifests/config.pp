# == Class: magnum::config
#
# This class is used to manage arbitrary magnum configurations.
#
# === Parameters
#
# [*magnum_config*]
#   (optional) Allow configuration of arbitrary magnum configurations.
#   The value is an hash of magnum_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   magnum_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*magnum_api_paste_ini*]
#   (optional) Allow configuration of /etc/magnum/api-paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class magnum::config (
  $magnum_config        = {},
  $magnum_api_paste_ini = {},
) {

  include ::magnum::deps

  validate_hash($magnum_config)
  validate_hash($magnum_api_paste_ini)

  create_resources('magnum_config', $magnum_config)
  create_resources('magnum_api_paste_ini', $magnum_api_paste_ini)
}
