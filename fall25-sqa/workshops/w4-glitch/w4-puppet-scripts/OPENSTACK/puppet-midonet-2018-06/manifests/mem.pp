# == Class: midonet::mem
#
# Install and configure Midokura Enterprise MidoNet (MEM)
#
# === Parameters
#
# [analytics_ip]
# IP Where the analytics service is running
#
# [cluster_ip]
# IP where the cluster service is running
#
# [is_insights]
# Whether using insights or not
#
# [mem_api_namespace]
# Namespace for the midonet api URI
#   Default: 'midonet-api'
#
# [mem_trace_namespace]
# Namespace for the midonet traces URI
#   Default: 'trace'
#
# [mem_analytics_namespace]
# Namespace for the midonet analytics URI
#   Default: 'analytics'
#
# [mem_package]
# Name of the MEM package
#
# [mem_install_path]
# Installation path of MEM package
#
#
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
# [mem_agent_config_api_namespace]
#   The default value for the api_namespace is set to conf which usually
#   does not have to be changed.
#   Default value: "mem_agent_config_api_namespace": "conf"
#
# [*mem_api_namespace*]
#   Path where the api endpoint is. Default 'midonet-api'
#
# [*mem_trace_namespace*]
#   Path where the analytics traces endpoint is. Default 'traces'
#
# [*mem_analytics_namespace*]
#   Path where the analyics endpoint is. Default 'analytics'
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
# [mem_apache_docroot]
#   Document root for mem vhost
#   Default: undef
#
# [mem_apache_port]
#   The port where apache for mem will run
#   Default: undef
#
# [mem_proxy_preserve_host]
#   Should configure proxy preserve host on apache?
#
# [is_ssl]
#   Does MEM use SSL?
#   Default: undef
#
# [ssl_cert]
#   SSL certificate path
#   Default: undef
#
# [ssl_key]
#   SSL key path
#   Default: undef
#
# [insights_ssl]
#   Is MEM Insights using SSL?
#   Default: undef
#
# [mem_api_port]
#   The port where the midonet api is listening
#   Default: '8181'
#
# [mem_trace_port]
#   The port where the midonet traces is listening
#   Default: '8460'
#
# [mem_analytics_port]
#   The port where the midonet analytics is listening
#   Default: '8000'
#
# [mem_api_port]
#   The port where the midonet subscription service is listening
#   Default: '8007'
#
# [mem_fabric_port]
#   The port where the midonet fabric service is listening
#   Default: '8009'
#
# [api_ssl]
#   Is midonet api using SSL?
#   Default: false
# == Examples
#
# The minimum parameters required are
#
#    class {'midonet::mem':
#      cluster_ip            => '127.0.0.1',
#      analytics_ip          => '127.0.0.1',
#    }
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2016 Midokura SARL, All Rights Reserved.

class midonet::mem(
# Midonet Manager installation options
  $analytics_ip                   = $::ipaddress,
  $cluster_ip                     = $::ipaddress,
  $is_insights                    = false,
  $mem_api_namespace              = 'midonet-api',
  $mem_trace_namespace            = 'trace',
  $mem_analytics_namespace        = 'analytics',
  $mem_package                    = $::midonet::params::mem_package,
  $mem_install_path               = $::midonet::params::mem_install_path,
  $mem_api_version                = $::midonet::params::mem_api_version,
  $mem_api_token                  = $::midonet::params::mem_api_token,
  $mem_agent_config_api_namespace = $::midonet::params::mem_agent_config_api_namespace,
  $mem_poll_enabled               = $::midonet::params::mem_poll_enabled,
  $mem_login_animation_enabled    = $::midonet::params::mem_login_animation_enabled,
  $mem_config_file                = $::midonet::params::mem_config_file,
  $mem_apache_docroot             = undef,
  $mem_apache_port                = undef,
  $mem_proxy_preserve_host        = undef,
  $is_ssl                         = false,
  $ssl_cert                       = '',
  $ssl_key                        = '',
  $insights_ssl                   = false,
  $mem_api_port                   = ':8181',
  $mem_trace_port                 = ':8460',
  $mem_analytics_port             = ':8080',
  $mem_subscription_port          = ':8007',
  $mem_fabric_port                = ':8009',
  $api_ssl                        = false,

) inherits midonet::params {

  $mem_ws    = $insights_ssl? {true => 'wss://' , default => 'ws://'}
  $api_proto = $api_ssl? {true => 'https://' , default    => 'http://'}


  validate_bool($mem_api_token)
  validate_bool($mem_poll_enabled)
  validate_bool($mem_login_animation_enabled)
  validate_string($mem_package)
  validate_string($mem_install_path)
  validate_string($mem_api_namespace)
  validate_string($mem_api_version)
  validate_string($mem_config_file)
  validate_string($mem_agent_config_api_namespace)

  $mem_login_host                 = "${api_proto}${cluster_ip}${mem_api_port}"
  $mem_trace_api_host             = "${api_proto}${cluster_ip}${mem_api_port}"
  $mem_traces_ws_url              = "${mem_ws}${cluster_ip}${mem_trace_port}/${mem_trace_namespace}"
  $mem_api_host                   = "${api_proto}${cluster_ip}${mem_api_port}"
  $mem_analytics_ws_api_url       = "${mem_ws}${analytics_ip}${mem_analytics_port}/${mem_analytics_namespace}"
  $mem_subscriptions_ws_api_url   = "${mem_ws}${cluster_ip}${mem_subscription_port}/subscription"
  $mem_fabric_ws_api_url          = "${mem_ws}${cluster_ip}${mem_fabric_port}/fabric"
  $mem_apache_servername          = $cluster_ip


  package { 'midonet-manager':
    ensure => installed,
    name   => $mem_package
  }

  file { 'midonet-manager-config':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => "${mem_install_path}/config/client.js",
    content => template("${module_name}/manager/client.js.erb"),
    require => Package['midonet-manager']
  }

  if $is_ssl {
    if $ssl_cert == '' or $ssl_key == '' {
      fail('SSL key and cert are empty. Please provide value for them Or make is_ssl - false')
    }
    class {'midonet::mem::vhost':
      cluster_ip              => $cluster_ip,
      analytics_ip            => $analytics_ip,
      is_insights             => $is_insights,
      mem_apache_servername   => $mem_apache_servername,
      mem_apache_docroot      => $mem_apache_docroot,
      mem_api_namespace       => $mem_api_namespace,
      mem_trace_namespace     => $mem_trace_namespace,
      mem_analytics_namespace => $mem_analytics_namespace,
      mem_proxy_preserve_host => $mem_proxy_preserve_host,
      mem_apache_port         => $mem_apache_port,
      mem_ws                  => $mem_ws,
      is_ssl                  => $is_ssl,
      ssl_cert                => $ssl_cert,
      ssl_key                 => $ssl_key,
      mem_api_port            => $mem_api_port,
      mem_trace_port          => $mem_trace_port,
      mem_analytics_port      => $mem_analytics_port,
    }
  }
  else {
    Apache::Vhost<| access_log_file == 'horizon_access.log' |> {
      aliases +> [
        {
          alias => '/midonet-manager',
          path  => '/var/www/html/midonet-manager',
        }
      ],
      proxy_pass +> [
        { 'path' => '/midonet-api', 'url' => 'http://localhost:8181/midonet-api' },
      ],
      proxy_preserve_host =>  true
    }
  }
}
