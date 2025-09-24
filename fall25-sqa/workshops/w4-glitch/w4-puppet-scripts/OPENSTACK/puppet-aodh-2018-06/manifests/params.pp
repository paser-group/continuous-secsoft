# Parameters for puppet-aodh
#
class aodh::params {
  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }

  $client_package_name = "python${pyvers}-aodhclient"
  $group               = 'aodh'

  case $::osfamily {
    'RedHat': {
      $common_package_name     = 'openstack-aodh-common'
      $api_package_name        = 'openstack-aodh-api'
      $api_service_name        = 'openstack-aodh-api'
      $notifier_package_name   = 'openstack-aodh-notifier'
      $notifier_service_name   = 'openstack-aodh-notifier'
      $evaluator_package_name  = 'openstack-aodh-evaluator'
      $evaluator_service_name  = 'openstack-aodh-evaluator'
      $expirer_package_name    = 'openstack-aodh-expirer'

      # Deprecated in N, replaced with expirer_service_name
      $expirer_package_serice  = 'openstack-aodh-expirer'

      $expirer_service_name    = 'openstack-aodh-expirer'
      $listener_package_name   = 'openstack-aodh-listener'
      $listener_service_name   = 'openstack-aodh-listener'
      $aodh_wsgi_script_path   = '/var/www/cgi-bin/aodh'
      $aodh_wsgi_script_source = '/usr/bin/aodh-api'
      $redis_package_name      = 'python-redis'
    }
    'Debian': {
      $common_package_name     = 'aodh-common'
      $api_package_name        = 'aodh-api'
      $api_service_name        = 'aodh-api'
      $notifier_package_name   = 'aodh-notifier'
      $notifier_service_name   = 'aodh-notifier'
      $evaluator_package_name  = 'aodh-evaluator'
      $evaluator_service_name  = 'aodh-evaluator'
      $expirer_package_name    = 'aodh-expirer'

      # Deprecated in N, replaced with expirer_service_name
      $expirer_package_serice  = 'aodh-expirer'

      $expirer_service_name    = 'aodh-expirer'
      $listener_package_name   = 'aodh-listener'
      $listener_service_name   = 'aodh-listener'
      $aodh_wsgi_script_path   = '/usr/lib/cgi-bin/aodh'
      $aodh_wsgi_script_source = '/usr/share/aodh/app.wsgi'
      $redis_package_name      = "python${pyvers}-redis"
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
