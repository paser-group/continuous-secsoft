# == Class: rally::config
#
# This class is used to manage arbitrary rally configurations.
#
# === Parameters
#
# [*rally_config*]
#   (optional) Allow configuration of arbitrary rally configurations.
#   The value is an hash of rally_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   rally_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class rally::config (
  $rally_config = {},
) {

  include ::rally::deps

  validate_hash($rally_config)

  create_resources('rally_config', $rally_config)
}
