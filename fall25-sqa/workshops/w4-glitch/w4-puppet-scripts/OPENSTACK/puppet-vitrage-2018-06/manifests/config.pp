# == Class: vitrage::config
#
# This class is used to manage arbitrary vitrage configurations.
#
# === Parameters
#
# [*vitrage_config*]
#   (optional) Allow configuration of arbitrary vitrage configurations.
#   The value is an hash of vitrage_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   vitrage_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*vitrage_api_paste_ini*]
#   (optional) Allow configuration of /etc/vitrage/api-paste.ini options.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class vitrage::config (
  $vitrage_config     = {},
  $vitrage_api_paste_ini = {},
) {

  include ::vitrage::deps

  validate_hash($vitrage_config)
  validate_hash($vitrage_api_paste_ini)

  create_resources('vitrage_config', $vitrage_config)
  create_resources('vitrage_api_paste_ini', $vitrage_api_paste_ini)
}
