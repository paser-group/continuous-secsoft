# Parameters for puppet-watcher
#
class watcher::params {
  include ::openstacklib::defaults
  $group = 'watcher'

  if ($::os_package_type == 'debian') {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }

  case $::osfamily {
    'RedHat': {
      $api_service_name             = 'openstack-watcher-api'
      $api_package_name             = 'openstack-watcher-api'
      $common_package_name          = 'openstack-watcher-common'
      $applier_package_name         = 'openstack-watcher-applier'
      $applier_service_name         = 'openstack-watcher-applier'
      $decision_engine_package_name = 'openstack-watcher-decision-engine'
      $decision_engine_service_name = 'openstack-watcher-decision-engine'
      $client_package_name          = undef
      $watcher_wsgi_script_source   = '/usr/lib/python2.7/site-packages/watcher/api/app.wsgi'
      $watcher_wsgi_script_path     = '/var/www/cgi-bin/watcher'
    }
    'Debian': {
      $api_service_name             = 'watcher-api'
      $api_package_name             = 'watcher-api'
      $common_package_name          = 'watcher-common'
      $applier_package_name         = 'watcher-applier'
      $applier_service_name         = 'watcher-applier'
      $decision_engine_package_name = 'watcher-decision-engine'
      $decision_engine_service_name = 'watcher-decision-engine'
      $client_package_name          = "python${pyvers}-watcherclient"
      if ($::os_package_type == 'debian') {
        $watcher_wsgi_script_source = '/usr/share/watcher-common/app.wsgi'
      } else {
        $watcher_wsgi_script_source = '/usr/lib/python2.7/dist-packages/watcher/api/app.wsgi'
      }
      $watcher_wsgi_script_path     = '/usr/lib/cgi-bin/watcher'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
