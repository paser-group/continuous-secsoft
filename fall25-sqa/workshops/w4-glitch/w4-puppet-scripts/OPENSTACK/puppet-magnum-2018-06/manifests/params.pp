# ==Class: magnum::params
#
# Parameters for puppet-magnum
#
class magnum::params {
  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }

  $group = 'magnum'
  case $::osfamily {
    'RedHat': {
      # package names
      $common_package    = 'openstack-magnum-common'
      $api_package       = 'openstack-magnum-api'
      $conductor_package = 'openstack-magnum-conductor'
      # service names
      $api_service       = 'openstack-magnum-api'
      $conductor_service = 'openstack-magnum-conductor'
      $client_package    = 'python2-magnumclient'
    }
    'Debian': {
      # package names
      $common_package    = 'magnum-common'
      $api_package       = 'magnum-api'
      $conductor_package = 'magnum-conductor'
      # service names
      $api_service       = 'magnum-api'
      $conductor_service = 'magnum-conductor'
      $client_package    = "python${pyvers}-magnumclient"
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
