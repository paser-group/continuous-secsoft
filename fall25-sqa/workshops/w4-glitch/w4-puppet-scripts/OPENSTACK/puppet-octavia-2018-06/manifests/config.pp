# == Class: octavia::config
#
# This class is used to manage arbitrary octavia configurations.
#
# === Parameters
#
# [*octavia_config*]
#   (optional) Allow configuration of arbitrary octavia configurations.
#   The value is an hash of octavia_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   octavia_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class octavia::config (
  $octavia_config = {},
) {

  include ::octavia::deps

  validate_hash($octavia_config)

  create_resources('octavia_config', $octavia_config)
}
