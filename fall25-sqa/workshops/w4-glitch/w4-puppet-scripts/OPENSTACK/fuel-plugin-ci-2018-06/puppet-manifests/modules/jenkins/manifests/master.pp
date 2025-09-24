# Class: jenkins::master
#
class jenkins::master (
  $service_fqdn                     = $::fqdn,
  # Firewall access
  $apply_firewall_rules             = false,
  $firewall_allow_sources           = [],
  # Nginx parameters
  # Jenkins user keys
  $jenkins_ssh_private_key_contents = '',
  $jenkins_ssh_public_key_contents  = '',
  $ssl_cert_file                    = $::jenkins::params::ssl_cert_file,
  $ssl_cert_file_contents           = $::jenkins::params::ssl_cert_file_contents,
  $ssl_key_file                     = '/etc/ssl/jenkins.key',
  $ssl_key_file_contents            = '',
  # Jenkins config parameters
  $install_label_dumper             = false,
  $install_zabbix_item              = false,
  $jenkins_address                  = '0.0.0.0',
  $jenkins_java_args                = '',
  $jenkins_port                     = '8080',
  $jenkins_proto                    = 'http',
  $label_dumper_nginx_location      = '/labels',
  $nginx_access_log                 = '/var/log/nginx/access.log',
  $nginx_error_log                  = '/var/log/nginx/error.log',
  $www_root                         = '/var/www',
  # Jenkins auth
  $install_groovy                   = 'yes',
  $jenkins_cli_file                 = '/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar',
  $jenkins_cli_tries                = '6',
  $jenkins_cli_try_sleep            = '30',
  $jenkins_libdir                   = '/var/lib/jenkins',
  $jenkins_management_email         = '',
  $jenkins_management_login         = '',
  $jenkins_management_name          = '',
  $jenkins_management_password      = '',
  $jenkins_s2m_acl                  = true,
  $ldap_access_group                = '',
  $ldap_group_search_base           = '',
  $ldap_inhibit_root_dn             = 'no',
  $ldap_manager                     = '',
  $ldap_manager_passwd              = '',
  $ldap_overwrite_permissions       = '',
  $ldap_root_dn                     = 'dc=company,dc=net',
  $ldap_uri                         = 'ldap://ldap',
  $ldap_user_search                 = 'uid={0}',
  $ldap_user_search_base            = '',
  $security_model                   = 'unsecured',
) inherits ::jenkins::params{

  # Install base packages

  package { 'openjdk-7-jre-headless':
    ensure => present,
  }

  package { 'openjdk-6-jre-headless':
    ensure  => purged,
    require => Package['openjdk-7-jre-headless'],
  }

  if($install_groovy) {
    package { 'groovy' :
      ensure => present,
    }
  }

  package { 'jenkins' :
    ensure => present,
  }

  service { 'jenkins' :
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => false,
  }

  Package['openjdk-7-jre-headless'] ~>
  Package['jenkins'] ~>
  Service['jenkins']

  file { '/etc/default/jenkins':
    ensure  => present,
    mode    => '0644',
    content => template('jenkins/jenkins.erb'),
    require => Package['jenkins'],
  }

  ensure_resource('user', 'jenkins', {
    ensure     => 'present',
    home       => $jenkins_libdir,
    managehome => true,
  })

  file { "${jenkins_libdir}/.ssh/" :
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0700',
    require => User['jenkins'],
  }

  file { "${jenkins_libdir}/.ssh/id_rsa" :
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0600',
    content => $jenkins_ssh_private_key_contents,
    replace => true,
    require => File["${jenkins_libdir}/.ssh/"],
  }

  file { "${jenkins_libdir}/.ssh/id_rsa.pub" :
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0644',
    content => "${jenkins_ssh_public_key_contents} jenkins@${::fqdn}",
    replace => true,
    require => File["${jenkins_libdir}/.ssh"],
  }

  ensure_resource('file', $www_root, {'ensure' => 'directory' })

  # Setup nginx

  if (!defined(Class['::nginx'])) {
    class { '::nginx' :}
  }

  ::nginx::resource::vhost { 'jenkins-http' :
    ensure              => 'present',
    listen_port         => 80,
    server_name         => [$service_fqdn, $::fqdn],
    www_root            => $www_root,
    access_log          => $nginx_access_log,
    error_log           => $nginx_error_log,
    location_cfg_append => {
      return => "301 https://${service_fqdn}\$request_uri",
    },
  }
  ::nginx::resource::vhost { 'jenkins' :
    ensure              => 'present',
    listen_port         => 443,
    server_name         => [$service_fqdn, $::fqdn],
    ssl                 => true,
    ssl_cert            => $ssl_cert_file,
    ssl_key             => $ssl_key_file,
    ssl_cache           => 'shared:SSL:10m',
    ssl_session_timeout => '10m',
    ssl_stapling        => true,
    ssl_stapling_verify => true,
    proxy               => 'http://127.0.0.1:8080',
    proxy_read_timeout  => 120,
    access_log          => $nginx_access_log,
    error_log           => $nginx_error_log,
    location_cfg_append => {
      client_max_body_size => '8G',
      proxy_redirect       => 'off',
      proxy_set_header     => {
        'X-Forwarded-For'   => '$remote_addr',
        'X-Forwarded-Proto' => 'https',
        'X-Real-IP'         => '$remote_addr',
        'Host'              => '$host',
      },
    },
  }

  if $ssl_cert_file_contents != '' {
    file { $ssl_cert_file:
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => $ssl_cert_file_contents,
      before  => Nginx::Resource::Vhost['jenkins'],
    }
  }

  if $ssl_key_file_contents != '' {
    file { $ssl_key_file:
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => $ssl_key_file_contents,
      before  => Nginx::Resource::Vhost['jenkins'],
    }
  }

  if($install_zabbix_item) {
    file { '/usr/local/bin/jenkins_items.py' :
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('jenkins/jenkins_items.py.erb'),
    }

    ::zabbix::item { 'jenkins' :
      template => 'jenkins/zabbix_item.conf.erb',
      require  => File['/usr/local/bin/jenkins_items.py'],
    }
  }

  if($install_label_dumper) {
    file { '/usr/local/bin/labeldump.py' :
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      content => template('jenkins/labeldump.py.erb'),
    }

    cron { 'labeldump-cronjob' :
      command => '/usr/bin/test -f /tmp/jenkins.is.fine && /usr/local/bin/labeldump.py 2>&1 | logger -t labeldump',
      user    => 'root',
      hour    => '*',
      minute  => '*/30',
      require => File['/usr/local/bin/labeldump.py'],
    }

    file { "${www_root}${label_dumper_nginx_location}" :
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    ::nginx::resource::location { 'labels' :
      ensure   => 'present',
      ssl      => true,
      ssl_only => true,
      location => $label_dumper_nginx_location,
      vhost    => 'jenkins',
      www_root => $www_root,
    }
  }

  if $apply_firewall_rules {
    include firewall_defaults::pre
    create_resources(firewall, $firewall_allow_sources, {
      dport   => [80, 443],
      action  => 'accept',
      require => Class['firewall_defaults::pre'],
    })
  }

  # Prepare groovy script
  file { "${jenkins_libdir}/jenkins_cli.groovy":
    ensure  => present,
    source  => ('puppet:///modules/jenkins/jenkins_cli.groovy'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['groovy'],
  }

  if $security_model == 'unsecured' {
    $security_opt_params = 'set_unsecured'
  }

  if $security_model == 'ldap' {
    $security_opt_params = join([
      'set_security_ldap',
      "'${ldap_overwrite_permissions}'",
      "'${ldap_access_group}'",
      "'${ldap_uri}'",
      "'${ldap_root_dn}'",
      "'${ldap_user_search}'",
      "'${ldap_inhibit_root_dn}'",
      "'${ldap_user_search_base}'",
      "'${ldap_group_search_base}'",
      "'${ldap_manager}'",
      "'${ldap_manager_passwd}'",
      "'${jenkins_management_login}'",
      "'${jenkins_management_email}'",
      "'${jenkins_management_password}'",
      "'${jenkins_management_name}'",
      "'${jenkins_ssh_public_key_contents}'",
      "'${jenkins_s2m_acl}'",
    ], ' ')
  }

  if $security_model == 'password' {
    $security_opt_params = join([
      'set_security_password',
      "'${jenkins_management_login}'",
      "'${jenkins_management_email}'",
      "'${jenkins_management_password}'",
      "'${jenkins_management_name}'",
      "'${jenkins_ssh_public_key_contents}'",
      "'${jenkins_s2m_acl}'",
    ], ' ')
  }

  # Execute groovy script to setup auth
  exec { 'jenkins_auth_config':
    require   => [
      File["${jenkins_libdir}/jenkins_cli.groovy"],
      Package['groovy'],
      Service['jenkins'],
    ],
    command   => join([
        '/usr/bin/java',
        "-jar ${jenkins_cli_file}",
        "-s ${jenkins_proto}://${jenkins_address}:${jenkins_port}",
        "groovy ${jenkins_libdir}/jenkins_cli.groovy",
        $security_opt_params,
    ], ' '),
    tries     => $jenkins_cli_tries,
    try_sleep => $jenkins_cli_try_sleep,
    user      => 'jenkins',
  }
}
