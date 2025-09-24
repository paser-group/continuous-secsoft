# Parameters for puppet-tacker
#
class tacker::params {
  include openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers

  $group = 'tacker'
  $client_package_name = "python${pyvers}-tackerclient"

  case $::osfamily {
    'RedHat': {
      $package_name     = 'openstack-tacker'
      $service_name     = 'openstack-tacker-server'
    }
    'Debian': {
      $package_name     = 'tacker'
      $service_name     = 'tacker'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    } # Case $::osfamily
  }
}
