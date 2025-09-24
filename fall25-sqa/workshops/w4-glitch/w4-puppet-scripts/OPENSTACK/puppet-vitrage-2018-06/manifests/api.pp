# Installs & configure the vitrage api service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*host*]
#   (optional) The vitrage api bind address.
#   Defaults to '0.0.0.0'
#
# [*port*]
#   (optional) The vitrage api port.
#   Defaults to '8999'
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of vitrage-api.
#   If the value is 'httpd', this means vitrage-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'vitrage::wsgi::apache'...}
#   to make vitrage-api be a web app using apache mod_wsgi.
#   Defaults to '$::vitrage::params::api_service_name'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
class vitrage::api (
  $manage_service               = true,
  $enabled                      = true,
  $package_ensure               = 'present',
  $host                         = '0.0.0.0',
  $port                         = '8999',
  $service_name                 = $::vitrage::params::api_service_name,
  $enable_proxy_headers_parsing = $::os_service_default,
) inherits vitrage::params {

  include ::vitrage::deps
  include ::vitrage::params
  include ::vitrage::policy

  package { 'vitrage-api':
    ensure => $package_ensure,
    name   => $::vitrage::params::api_package_name,
    tag    => ['openstack', 'vitrage-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $service_name == $::vitrage::params::api_service_name {
    service { 'vitrage-api':
      ensure     => $service_ensure,
      name       => $::vitrage::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => 'vitrage-service',
    }
  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { 'vitrage-api':
      ensure => 'stopped',
      name   => $::vitrage::params::api_service_name,
      enable => false,
      tag    => 'vitrage-service',
    }

    # we need to make sure vitrage-api/eventlet is stopped before trying to start apache
    Service['vitrage-api'] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either vitrage/openstack-vitrage-api for running \
as a standalone service, or httpd for being run by a httpd server")
  }

  vitrage_config {
    'api/host'                             : value => $host;
    'api/port'                             : value => $port;
  }

  oslo::middleware { 'vitrage_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

}
