# == Class: watcher::api
#
# Configure Watcher API service.
#
# === Parameters:
#
# All options are optional unless specified otherwise.
# All options defaults to $::os_service_default and
# the default values from the service are used.
#
# === Watcher configuration section: watcher_clients_auth
#
# [*watcher_client_password*]
#   (required) User's password
#
# [*watcher_client_username*]
#   (optional) The name of the auth user
#   Defaults to watcher.
#
# [*watcher_client_auth_uri*]
#   (Optional) Public Identity API endpoint.
#   Defaults to 'http://localhost:5000/'
#
# [*watcher_client_auth_url*]
#   Specifies the admin Identity URI for Watcher to use.
#   Default 'http://localhost:5000/'
#
# [*package_ensure*]
#   (Optional)Ensure state of the openstackclient package.
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) Whether the watcher api service will be run
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*validate*]
#   (Optional) Whether to validate the service is working after any service
#   refreshes
#   Defaults to false
#
# [*watcher_api_port*]
#   (Optional) The port on which the watcher API will listen.
#   Defaults to 9322.
#
# [*watcher_api_max_limit*]
#   (Optional)The maximum number of items returned in a single response from a
#   collection resource.
#   Defaults to $::os_service_default
#
# [*watcher_api_bind_host*]
#   (Optional) Listen IP for the watcher API server.
#   Defaults to '0.0.0.0'.
#
# [*watcher_api_workers*]
#   (Optional) Number of worker processors to for the Watcher API service.
#   Defaults to $::os_workers.
#
# [*watcher_api_enable_ssl_api*]
#   (Optional) Enable the integrated stand-alone API to service requests via HTTPS instead
#   of HTTP. If there is a front-end service performing HTTPS offloading from the
#   service, this option should be False; note, you will want to change public
#   API endpoint to represent SSL termination URL with 'public_endpoint' option.
#   Defaults to $::os_service_default.
#
# [*watcher_client_default_domain_name*]
#   (Optional)domain name to use with v3 API and v2 parameters. It will
#   be used for both the user and project domain in v3 and ignored in v2
#   authentication.
#   Defaults to $::os_service_default
#
# [*watcher_client_project_name*]
#   (Optional) Service project name.
#   Defaults to undef
#
# [*watcher_client_certfile*]
#   (Optional) PEM encoded client certificate cert file.
#   Defaults to undef
#
# [*watcher_client_cafile*]
#   (Optional)PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to undef
#
# [*watcher_client_project_domain_name*]
#   (Optional) Domain name containing project.
#   Defaults to undef
#
# [*watcher_client_insecure*]
#   (Optional) Verify HTTPS connections.
#   Defaults to undef
#
# [*watcher_client_keyfile*]
#   (Optional) PEM encoded client certificate key file.
#   Defaults to undef
#
# [*watcher_client_auth_type*]
#   (Optional) Authentication type to load.
#   Defaults to undef
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of watcher-api.
#   If the value is 'httpd', this means watcher-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'watcher::wsgi::apache'...}
#   to make watcher-api be a web app using apache mod_wsgi.
#   Defaults to '$::watcher::params::api_service_name'
#
# === Watcher API service validation
#
# [*validation_options*]
#   (Optional) Service validation options
#   Should be a hash of options defined in openstacklib::service_validation
#   If empty, defaults values are taken from openstacklib function.
#   Require validate set at True.
#   Defaults to {}
#
# === DB management
#
# [*create_db_schema*]
#   (Optional) Run watcher-db-manage create_schema on api nodes after
#   installing the package.
#   Defaults to false
#
# [*upgrade_db*]
#   (Optional) Run watcher-db-manage upgrade on api nodes after
#   installing the package.
#   Defaults to false
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
class watcher::api (
  $watcher_client_password,
  $watcher_client_username            = 'watcher',
  $watcher_client_auth_uri            = 'http://localhost:5000/',
  $watcher_client_auth_url            = 'http://localhost:5000/',
  $package_ensure                     = 'present',
  $enabled                            = true,
  $manage_service                     = true,
  $validate                           = false,
  $watcher_api_port                   = '9322',
  $watcher_api_max_limit              = $::os_service_default,
  $watcher_api_bind_host              = '0.0.0.0',
  $watcher_api_workers                = $::os_workers,
  $watcher_api_enable_ssl_api         = $::os_service_default,
  $watcher_client_default_domain_name = $::os_service_default,
  $watcher_client_project_name        = 'service',
  $watcher_client_certfile            = $::os_service_default,
  $watcher_client_cafile              = $::os_service_default,
  $watcher_client_project_domain_name = $::os_service_default,
  $watcher_client_insecure            = $::os_service_default,
  $watcher_client_keyfile             = $::os_service_default,
  $watcher_client_auth_type           = 'password',
  $validation_options                 = {},
  $service_name                       = $::watcher::params::api_service_name,
  $create_db_schema                   = false,
  $upgrade_db                         = false,
  $auth_strategy                      = 'keystone',
) inherits watcher::params {

  include ::watcher::policy
  include ::watcher::deps

  if $auth_strategy == 'keystone' {
    include ::watcher::keystone::authtoken
  }

  validate_string($watcher_client_password)

  package { 'watcher-api':
    ensure => $package_ensure,
    name   => $::watcher::params::api_package_name,
    tag    => ['openstack', 'watcher-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  if $create_db_schema {
    include ::watcher::db::create_schema
  }

  if $upgrade_db {
    include ::watcher::db::upgrade
  }

  if $service_name == $::watcher::params::api_service_name {
    # NOTE(danpawlik) Watcher doesn't support db_sync command.
    service { 'watcher-api':
      ensure     => $service_ensure,
      name       => $::watcher::params::api_service_name,
      enable     => $enabled,
      hasstatus  => true,
      hasrestart => true,
      tag        => [ 'watcher-service',
                      'watcher-db-manage-create_schema',
                      'watcher-db-manage-upgrade'],
    }
  } elsif $service_name == 'httpd' {
    include ::apache::params
    service { 'watcher-api':
      ensure => 'stopped',
      name   => $::watcher::params::api_service_name,
      enable => false,
      tag    => [ 'watcher-service',
                  'watcher-db-manage-create_schema',
                  'watcher-db-manage-upgrade'],
    }

    # we need to make sure watcher-api/eventlet is stopped before trying to start apache
    Service['watcher-api'] -> Service[$service_name]
  } else {
    fail("Invalid service_name. Either watcher/openstack-watcher-api for running \
as a standalone service, or httpd for being run by a httpd server")
  }

  if $enabled {
    watcher_config {
      'api/port':           value => $watcher_api_port;
      'api/max_limit':      value => $watcher_api_max_limit;
      'api/host':           value => $watcher_api_bind_host;
      'api/workers':        value => $watcher_api_workers;
      'api/enable_ssl_api': value => $watcher_api_enable_ssl_api;
    }
  }

  # NOTE(danpawlik) Watcher and other core Openstack services are using
  # keystone_authtoken section and also another similar section used to
  # configure client auth credentials. So these parameters are similar to
  # parameters in watcher::keystone::authtoken.
  watcher_config {
    'watcher_clients_auth/username':            value => $watcher_client_username;
    'watcher_clients_auth/password':            value => $watcher_client_password, secret => true;
    'watcher_clients_auth/auth_url':            value => $watcher_client_auth_url;
    'watcher_clients_auth/auth_uri':            value => $watcher_client_auth_uri;
    'watcher_clients_auth/project_name':        value => $watcher_client_project_name;
    'watcher_clients_auth/project_domain_name': value => $watcher_client_project_domain_name;
    'watcher_clients_auth/insecure':            value => $watcher_client_insecure;
    'watcher_clients_auth/auth_type':           value => $watcher_client_auth_type;
    'watcher_clients_auth/cafile':              value => $watcher_client_cafile;
    'watcher_clients_auth/certfile':            value => $watcher_client_certfile;
    'watcher_clients_auth/keyfile':             value => $watcher_client_keyfile;
  }

  if $validate {
    $defaults = {
      'watcher-api' => {
        # lint:ignore:140chars
        'command'  => "watcher --os-auth-url ${watcher_client_auth_url} --os-project-name ${watcher_client_project_name} --os-username ${watcher_client_username} --os-password ${watcher_client_password} goal list",
        # lint:endignore
      }
    }
    $validation_options_hash = merge($defaults, $validation_options)
    create_resources('openstacklib::service_validation', $validation_options_hash, {'subscribe' => 'Anchor[watcher::service::end]'})
  }

}
