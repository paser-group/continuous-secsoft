# = Class: zaqar::server
#
# This class manages the Zaqar server.
#
# [*enabled*]
#   (Optional) Service enable state for zaqar-server.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the service is managed by this puppet class.
#   Defaults to true.
#
#  [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of zaqar-server
#   If the value is 'httpd', this means zaqar-server will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'zaqar::wsgi::apache'...}
#   to make zaqar-server be a web app using apache mod_wsgi.
#   Defaults to '$::zaqar::params::service_name'

#
class zaqar::server(
  $manage_service = true,
  $enabled        = true,
  $service_name   = $::zaqar::params::service_name,
) inherits zaqar::params {

  include ::zaqar
  include ::zaqar::deps
  include ::zaqar::params
  include ::zaqar::policy

  if $enabled {
    if $manage_service {
      $ensure = 'running'
    }
  } else {
    if $manage_service {
      $ensure = 'stopped'
    }
  }

  if $service_name == $::zaqar::params::service_name {
    service { $::zaqar::params::service_name:
      ensure    => $ensure,
      name      => $::zaqar::params::service_name,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'zaqar-service',
    }

  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { $::zaqar::params::service_name:
      ensure => 'stopped',
      name   => $::zaqar::params::service_name,
      enable => false,
      tag    => ['zaqar-service'],
    }

    # we need to make sure zaqar-server is stopped before trying to start apache
    Service[$::zaqar::params::service_name] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either zaqar-server/openstack-zaqar for \
running as a standalone service, or httpd for being run by a httpd server")
  }

}
