# == Class: vitrage::params
#
# Parameters for puppet-vitrage
#
class vitrage::params {
  include openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers
  $pyver3 = $::openstacklib::defaults::pyver3

  $client_package_name = "python${pyvers}-vitrageclient"
  $group               = 'vitrage'

  case $::osfamily {
    'RedHat': {
      $common_package_name         = 'openstack-vitrage-common'
      $api_package_name            = 'openstack-vitrage-api'
      $api_service_name            = 'openstack-vitrage-api'
      $notifier_package_name       = 'openstack-vitrage-notifier'
      $notifier_service_name       = 'openstack-vitrage-notifier'
      $graph_package_name          = 'openstack-vitrage-graph'
      $graph_service_name          = 'openstack-vitrage-graph'
      $persistor_package_name      = 'openstack-vitrage-persistor'
      $persistor_service_name      = 'openstack-vitrage-persistor'
      $vitrage_wsgi_script_path    = '/var/www/cgi-bin/vitrage'
      $vitrage_wsgi_script_source  = "/usr/lib/python${pyver3}/site-packages/vitrage/api/app.wsgi"
    }
    'Debian': {
      $common_package_name         = 'vitrage-common'
      $api_package_name            = 'vitrage-api'
      $api_service_name            = 'vitrage-api'
      $notifier_package_name       = 'vitrage-notifier'
      $notifier_service_name       = 'vitrage-notifier'
      $graph_package_name          = 'vitrage-graph'
      $graph_service_name          = 'vitrage-graph'
      $persistor_package_name      = 'vitrage-persistor'
      $persistor_service_name      = 'vitrage-persistor'
      $vitrage_wsgi_script_path    = '/usr/lib/cgi-bin/vitrage'
      $vitrage_wsgi_script_source  = '/usr/share/vitrage-common/app.wsgi'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
