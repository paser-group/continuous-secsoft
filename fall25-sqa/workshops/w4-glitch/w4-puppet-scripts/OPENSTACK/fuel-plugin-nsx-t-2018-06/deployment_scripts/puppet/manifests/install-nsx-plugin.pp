notice('fuel-plugin-nsx-t: install-nsx-plugin.pp')

include ::nsxt::params

package { $::nsxt::params::plugin_package:
  ensure => present,
}

