# == Class: ec2api::params
#
# These parameters need to be accessed from several locations and
# should be considered to be constant
#
class ec2api::params {
  include ::openstacklib::defaults
  $group = 'ec2api'
  case $::osfamily {
    'RedHat': {
      $package_name          = 'openstack-ec2-api'
      $api_service_name      = 'openstack-ec2-api'
      $metadata_service_name = 'openstack-ec2-api-metadata'
    }
    'Debian': {
      # FIXME: Correct these variables once UCA provides ec2-api packaging
      $package_name          = 'ec2api'
      $api_service_name      = 'ec2-api'
      $metadata_service_name = 'ec2-api-metadata'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }
  }
}
