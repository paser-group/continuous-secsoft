notice('fuel-plugin-nsx-t: hiera-override.pp')

include ::nsxt::params

class { '::nsxt::hiera_override':
  override_file_name => $::nsxt::params::hiera_key,
}
