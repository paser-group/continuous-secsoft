# == Class: midonet::mem::vhost
#
# This class installs apache2/httpd server and configures a custom virtualhost
# for midonet-manager.
#
# === Parameters
#
# [*analytics_ip*]
#  The public IP of where the analytics service is listening.
#     Default : $::ipaddress
#
# [*cluster_ip*]
#  The public IP of where
#     Default: $::ipaddress
#
# [*is_insights*]
#   Boolean defining if insights is being used or not
#     Default: false
#
# [*insights_ssl*]
#   Is mem insights using ssl?
#     Default: false
#
# [*manage_apache_mods*]
#   Install apache mods?
#     Default: true
#
# [*mem_apache_servername*]
#   Servername for the mem vhost
#
# [*mem_apache_docroot*]
#   Document root for mem vhost. Default '/var/www/html'
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
# [*mem_proxy_preserve_host*]
#   Use proxypreservehost directive
#     Default: true
#
# [*mem_apache_port*]
#   Port where apache will listen for midonet-manager. Default is '80'
#
# [*mem_ws*]
#   Whether to use ws or wss ?
#
# [*is_ssl*]
#   Whether use ssl or not
#     Default: undef
#
# [*ssl_cert*]
#   Ssl certificate
#     Default: undef
#
# [*ssl_key*]
#   Ssl key
#     Default: undef
#
# [*priority*]
#   priority of the mem vhost
#     Default: undef
#
# [*mem_api_port*]
#   Port where midonet api is listening to
#     Default: '8181'
#
# [*mem_apache_port*]
#   Port where traces endpoint is listening
#     Default: '8460'
#
# [*mem_analytics_port*]
#   Port where analytics service is listening to.
#     Default: '8080'
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2016 Midokura SARL, All Rights Reserved.

class midonet::mem::vhost (
  $analytics_ip             = $::ipaddress,
  $cluster_ip               = $::ipaddress,
  $is_insights              = false,
  $insights_ssl             = false,
  $manage_apache_mods       = true,
  $mem_apache_servername    = $::midonet::params::mem_apache_servername,
  $mem_apache_docroot       = $::midonet::params::mem_apache_docroot,
  $mem_api_namespace        = $::midonet::params::mem_api_namespace,
  $mem_trace_namespace      = $::midonet::params::mem_trace_namespace,
  $mem_analytics_namespace  = $::midonet::params::mem_analytics_namespace,
  $mem_proxy_preserve_host  = $::midonet::params::mem_proxy_preserve_host,
  $mem_apache_port          = $::midonet::params::mem_apache_port,
  $mem_ws                   = undef,
  $is_ssl                   = undef,
  $ssl_cert                 = undef,
  $ssl_key                  = undef,
  $priority                 = undef,
  $mem_api_port             = '8181',
  $mem_trace_port           = '8460',
  $mem_analytics_port       = '8080',
) inherits midonet::params {

  $aliases = [
    {
      'alias' => 'midonet-manager',
      'path'  => '/var/www/html/midonet-manager',
    },
  ]

  $headers     = [
    'set    Access-Control-Allow-Origin  *',
    'append Access-Control-Allow-Headers Content-Type',
    'append Access-Control-Allow-Headers X-Auth-Token',
  ]

  $mem_ws_proto = $insights_ssl? {true => 'wss://' , default => 'ws://'}
  if $is_insights {

    $proxy_pass = [
      {
        'path' => "/${mem_api_namespace}",
        'url'  => "http://${cluster_ip}:${mem_api_port}/${mem_api_namespace}",
      },
      {
        'path' => "/${mem_trace_namespace}",
        'url'  => "${mem_ws_proto}://${cluster_ip}:${mem_trace_port}/${mem_trace_namespace}",
      },
      {
        'path' => "/${mem_analytics_namespace}",
        'url'  => "${mem_ws_proto}${analytics_ip}:${mem_analytics_port}/${mem_analytics_namespace}",
      },
    ]
  }
  else {

    $proxy_pass = [
      {
        'path' => "/${mem_api_namespace}",
        'url'  => "http://${cluster_ip}:${mem_api_port}/${mem_api_namespace}",
      },
      {
        'path' => "/${mem_trace_namespace}",
        'url'  => "${mem_ws_proto}://${cluster_ip}:${mem_trace_port}/${mem_trace_namespace}",
      },
    ]
  }


  validate_array($proxy_pass)
  validate_string($mem_apache_docroot)

  if ($manage_apache_mods) {

  include ::apache
  include ::apache::mod::headers
  include ::apache::mod::proxy
  include ::apache::mod::proxy_http
  include ::apache::mod::ssl
}

  if $is_ssl {
    apache::vhost { 'midonet-mem':
      servername                  => $mem_apache_servername,
      docroot                     => $mem_apache_docroot,
      proxy_preserve_host         => $mem_proxy_preserve_host,
      proxy_pass                  => $proxy_pass,
      headers                     => $headers,
      aliases                     => $aliases,
      ssl                         => true,
      ssl_proxyengine             => true,
      ssl_cert                    => $ssl_cert,
      ssl_key                     => $ssl_key,
      ssl_proxy_verify            => none,
      ssl_proxy_check_peer_cn     => off,
      ssl_proxy_check_peer_name   => off,
      ssl_proxy_check_peer_expire => off,
      priority                    => $priority,
      require                     => [Package[$midonet::params::mem_package],Class['::apache::mod::ssl']],
    }
  }
  else {
    apache::vhost { 'midonet-mem':
      servername          => $mem_apache_servername,
      docroot             => $mem_apache_docroot,
      proxy_preserve_host => $mem_proxy_preserve_host,
      proxy_pass          => $proxy_pass,
      headers             => $headers,
      aliases             => $aliases,
      priority            => $priority,
      require             => Package[$midonet::params::mem_package],
    }
  }
}
