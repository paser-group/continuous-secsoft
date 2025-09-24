# == Class = midonet::params
#
# Configure the parameters for midonet module
#
# === Parameters
#
# [*midonet_repo_baseurl*]
#   Address of the midonet repository
#
# [midonet_key_url]
#   Url to get the GPG key for the repository
#
# [mem_package]
#   Name of the Midonet MEM package
#
# [mem_install_path]
#   Path where the midonet-manager files will be deploy_end
# [mem_agent_config_api_namespace]
#   The default value for the api_namespace is set to conf which usually
#   does not have to be changed.
#   Default value: "mem_agent_config_api_namespace": "conf"
# [mem_api_version]
#   The default value for the api_version is set to latest version. In case you
#   are using and older MidoNet REST API, change the version accordingly.
#   Note: The MidoNet Manager supports the following API versions: 5.0 , 5.2
#   e.g. "api_version": "5.2"
#
# [mem_api_token]
#   If desired, auto-login can be enabled by setting the value of api_token to
#   your Keystone token.
#   e.g. "mem_api_token": keystone_token
#
# [mem_poll_enabled]
#   The Auto Polling will seamlessly refresh Midonet Manager data periodically.
#   It is enabled by default and can be disabled in Midonet Manager's Settings
#   section directly through the UI. This will only disable it for the duration
#   of the current session. It can also be disabled permanently by changing the
#   'poll_enabled' parameter to 'false'
#
# [mem_login_animation_enabled]
#   Whether the login page background animation should be enabled or not
#   Default: true
#
# [mem_config_file]
# File for the MEM manager frontend configuration
#   Default: "${mem_install_path}/config/client.js"
#
# [mem_api_namespace]
# Namespace for the midonet api URI
#   Default: 'midonet-api'
#
#
# [mem_trace_namespace]
# Namespace for the midonet traces URI
#   Default: 'trace'
#
# [mem_analytics_namespace]
# Namespace for the midonet analytics URI
#   Default: 'analytics'
#
# [mem_proxy_preserve_host]
#   Should configure proxy preserve host on apache?
#
# [mem_apache_docroot]
#   Document root for mem vhost
#   Default: undef
#
# [mem_apache_port]
#   The port where apache for mem will run
#   Default: undef
#
# [mem_apache_servername]
#   Servername for MEM vhost
#   Default: undef

class midonet::params {

  $midonet_repo_baseurl                 = 'builds.midonet.org'
  $midonet_key_url                      = "https://${midonet_repo_baseurl}/midorepo.key"

  # midonet MEM Manager
  $mem_package                          = 'midonet-manager'
  $mem_install_path                     = '/var/www/html/midonet-manager'


  # MEM Manager config.js parameters
  $mem_agent_config_api_namespace       = 'conf'
  $mem_api_token                        = false
  $mem_api_version                      = '5.2'
  $mem_poll_enabled                     = true
  $mem_login_animation_enabled          = true
  $mem_config_file                      = "${mem_install_path}/config/client.js"

  $mem_api_namespace                    = 'midonet-api'
  $mem_trace_namespace                  = 'trace'
  $mem_analytics_namespace              = 'analytics'
  $mem_proxy_preserve_host              = true


  # MEM vhost parameters for apache conf
  $mem_apache_port                      = '80'
  $mem_apache_servername                = $::ipaddress
  $mem_apache_docroot                   = '/var/www/html'


  # OS configuration
  $gem_bin_path                         = '/usr/bin/gem'
}
