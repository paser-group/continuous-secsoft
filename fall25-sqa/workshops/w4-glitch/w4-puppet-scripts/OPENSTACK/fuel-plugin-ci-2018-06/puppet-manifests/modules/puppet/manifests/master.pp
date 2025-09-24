# Class: puppet::master
#
class puppet::master (
  $apply_firewall_rules   = $::puppet::params::apply_firewall_rules,
  $autosign               = $::puppet::params::autosign,
  $config                 = $::puppet::params::config,
  $config_template        = $::puppet::params::master_config_template,
  $environment            = $::puppet::params::environment,
  $firewall_allow_sources = $::puppet::params::firewall_allow_sources,
  $hiera_backends         = $::puppet::params::hiera_backends,
  $hiera_config           = $::puppet::params::hiera_config,
  $hiera_config_template  = $::puppet::params::hiera_config_template,
  $hiera_hierarchy        = $::puppet::params::hiera_hierarchy,
  $hiera_json_datadir     = $::puppet::params::hiera_json_datadir,
  $hiera_logger           = $::puppet::params::hiera_logger,
  $hiera_merge_behavior   = $::puppet::params::hiera_merge_behavior,
  $hiera_yaml_datadir     = $::puppet::params::hiera_yaml_datadir,
  $nginx_access_log       = '/var/log/nginx/access.log',
  $nginx_error_log        = '/var/log/nginx/error.log',
  $nginx_log_format       = undef,
  $package                = $::puppet::params::master_package,
  $puppet_master_run_with = 'webrick', # or nginx+uwsgi
  $server                 = '',
  $service                = $::puppet::params::master_service,
) inherits ::puppet::params {
  puppet::config { 'master-config' :
    hiera_backends        => $hiera_backends,
    hiera_config          => $hiera_config,
    hiera_config_template => $hiera_config_template,
    hiera_hierarchy       => $hiera_hierarchy,
    hiera_json_datadir    => $hiera_json_datadir,
    hiera_logger          => $hiera_logger,
    hiera_merge_behavior  => $hiera_merge_behavior,
    hiera_yaml_datadir    => $hiera_yaml_datadir,
    config                => $config,
    config_template       => $config_template,
    environment           => $environment,
  }

  if (!defined(Package[$package])) {
    package { $package :
      ensure => 'present',
    }
  }

  if ($hiera_merge_behavior == 'deeper') {
    package { 'deep_merge' :
      ensure   => 'present',
      provider => 'gem',
    }
  }

  if ($puppet_master_run_with == 'webrick') {
    service { $service :
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => false,
      require    => [
        Package[$package],
        File[$puppet_config]
      ]
    }
  }
  elsif ($puppet_master_run_with == 'nginx+uwsgi') {
    service { $service :
      ensure  => 'stopped',
      enable  => false,
      require => Package[$package],
      notify  => Service[nginx],
    }
    if (!defined(Class['uwsgi'])) {
      class { 'uwsgi' :}
    }

    file { '/etc/puppet/rack' :
      ensure => 'directory',
    }

    file { '/etc/puppet/rack/config.ru' :
      ensure  => 'present',
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0644',
      content => template('puppet/config.ru.erb'),
      require => File['/etc/puppet/rack'],
      before  => Class['uwsgi'],
    }

    uwsgi::application { 'puppetmaster' :
      plugins => 'rack',
      rack    => '/etc/puppet/rack/config.ru',
      chdir   => '/etc/puppet/rack',
      env     => 'HOME=/var/lib/puppet',
      uid     => 'puppet',
      gid     => 'puppet',
      socket  => '127.0.0.1:8141',
    }

    if (!defined(Class['nginx'])) {
      class { '::nginx' :}
    }
    ::nginx::resource::vhost { 'puppetmaster' :
      ensure                 => 'present',
      listen_port            => 8140,
      ssl_port               => 8140,
      server_name            => [$::fqdn],
      ssl                    => true,
      ssl_cert               => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
      ssl_key                => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
      ssl_crl                => '/var/lib/puppet/ssl/crl.pem',
      ssl_client_certificate => '/var/lib/puppet/ssl/certs/ca.pem',
      ssl_verify_client      => 'optional',
      access_log             => $nginx_access_log,
      error_log              => $nginx_error_log,
      format_log             => $nginx_log_format,
      uwsgi                  => '127.0.0.1:8141',
      location_cfg_append    => {
        uwsgi_connect_timeout => '3m',
        uwsgi_read_timeout    => '3m',
        uwsgi_send_timeout    => '3m',
        uwsgi_modifier1       => 7,
        uwsgi_param           => {
          'SSL_CLIENT_S_DN'   => '$ssl_client_s_dn',
          'SSL_CLIENT_VERIFY' => '$ssl_client_verify',
        },
      }
    }
  } else {
    fail "Unknown value for puppet_master_run_with parameter: ${puppet_master_run_with}"
  }

  file { $hiera_config :
    ensure  => 'present',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0400',
    content => template($hiera_config_template),
    require => Package[$package]
  }

  if $apply_firewall_rules {
    include firewall_defaults::pre
    create_resources(firewall, $firewall_allow_sources, {
      dport   => '8140',
      action  => 'accept',
      require => Class['firewall_defaults::pre'],
    })
  }
}
