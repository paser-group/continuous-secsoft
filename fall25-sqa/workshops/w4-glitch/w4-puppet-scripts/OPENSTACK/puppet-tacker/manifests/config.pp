# == Class: tacker::config
#
# This class is used to manage arbitrary tacker configurations.
#
# === Parameters
#
# [*tacker_config*]
#   (optional) Allow configuration of arbitrary tacker configurations.
#   The value is an hash of tacker_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   tacker_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class tacker::config (
  $tacker_config = {},
) {

  include tacker::deps

  validate_legacy(Hash, 'validate_hash', $tacker_config)

  create_resources('tacker_config', $tacker_config)
}
