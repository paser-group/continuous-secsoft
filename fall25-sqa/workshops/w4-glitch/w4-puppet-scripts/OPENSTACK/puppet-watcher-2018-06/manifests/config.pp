# == Class: watcher::config
#
# This class is used to manage arbitrary watcher configurations.
#
# === Parameters
#
# [*watcher_config*]
#   (optional) Allow configuration of arbitrary watcher configurations.
#   The value is an hash of watcher_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   watcher_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class watcher::config (
  $watcher_config = {},
) {

  include ::watcher::deps

  validate_hash($watcher_config)

  create_resources('watcher_config', $watcher_config)
}
