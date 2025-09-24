# == Class: fuel_project::apps::mirror_npm
#
class fuel_project::apps::mirror_npm (
  $cron_frequency   = '*/5',
  $nginx_access_log = '/var/log/nginx/access.log',
  $nginx_error_log  = '/var/log/nginx/error.log',
  $nginx_log_format = 'proxy',
  $npm_dir          = '/var/www/npm_mirror',
  $parallelism      = 10,
  $recheck          = false,
  $service_fqdn     = $::fqdn,
  $upstream_mirror  = 'http://registry.npmjs.org/',
) {

  validate_bool(
    $recheck,
  )

  $packages = [
    'ruby',
    'ruby-dev',
  ]

  package { $packages :
    ensure => installed,
  }

  package { 'npm-mirror' :
    ensure   => '0.0.1',
    provider => gem,
    require  => Package[$packages],
  }

  ensure_resource('file', '/var/www', {
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  })

  file { $npm_dir :
    ensure  => 'directory',
    owner   => 'npmuser',
    group   => 'www-data',
    require => [
      User['npmuser'],
      File['/var/www'],
    ]
  }

  user { 'npmuser' :
    ensure     => 'present',
    home       => '/var/lib/npm',
    comment    => 'Service used to run npm mirror synchronization',
    managehome => true,
    system     => true,
  }

  file { '/etc/npm_mirror/' :
    ensure  => 'directory',
    owner   => 'npmuser',
    group   => 'npmuser',
    require => User['npmuser'],
  }

  file { '/etc/npm_mirror/config.yml' :
    ensure  => 'present',
    owner   => 'npmuser',
    group   => 'npmuser',
    mode    => '0644',
    content => template('fuel_project/apps/npm_mirror.erb'),
    replace => true,
    require => [
      User['npmuser'],
      File['/etc/npm_mirror/'],
    ],
  }

  ::nginx::resource::vhost { 'npm_mirror' :
    ensure               => 'present',
    access_log           => $nginx_access_log,
    error_log            => $nginx_error_log,
    format_log           => $nginx_log_format,
    www_root             => $npm_dir,
    server_name          => [$service_fqdn],
    index_files          => ['index.json'],
    use_default_location => false,
  }

  ::nginx::resource::location { 'etag' :
    ensure              => present,
    location            => '~ \.etag$',
    vhost               => 'npm_mirror',
    location_custom_cfg => {
      return => '404',
    },
  }

  ::nginx::resource::location { 'json' :
    ensure              => present,
    location            => '~ /index\.json$',
    vhost               => 'npm_mirror',
    location_custom_cfg => {
      default_type => 'application/json',
    },
  }

  ::nginx::resource::location { 'all' :
    ensure              => present,
    location            => '= /-/all/since',
    vhost               => 'npm_mirror',
    location_custom_cfg => {
      rewrite => '^ /-/all/',
    },
  }

  file { '/var/run/npm' :
    ensure  => 'directory',
    owner   => 'npmuser',
    group   => 'root',
    require => User['npmuser'],
  }

  cron { 'npm-mirror' :
    minute      => $cron_frequency,
    command     => 'flock -n /var/run/npm/mirror.lock timeout -k 2m 30m npm-mirror /etc/npm_mirror/config.yml 2>&1 | logger -t npm-mirror',
    environment => 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    user        => 'npmuser',
    require     => [
      User['npmuser'],
      File['/etc/npm_mirror/config.yml'],
    ],
  }

}
