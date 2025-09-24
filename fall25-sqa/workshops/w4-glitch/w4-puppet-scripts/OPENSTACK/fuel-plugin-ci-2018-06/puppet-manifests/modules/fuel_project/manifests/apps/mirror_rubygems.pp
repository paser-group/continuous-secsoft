# == Class: fuel_project::apps::mirror_rubygems
#
class fuel_project::apps::mirror_rubygems (
  $cron_frequency   = '*/5',
  $nginx_access_log = '/var/log/nginx/access.log',
  $nginx_error_log  = '/var/log/nginx/error.log',
  $nginx_log_format = 'proxy',
  $parallelism      = '10',
  $rubygems_dir     = '/var/www/rubygems_mirror',
  $service_fqdn     = $::fqdn,
  $upstream_mirror  = 'http://rubygems.org',
) {

  package { 'rubygems-mirror' :
    ensure   => '1.0.1',
    provider => gem,
  }

  ensure_resource('file', '/var/www', {
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  })

  file { $rubygems_dir :
    ensure  => 'directory',
    owner   => 'rubygems',
    group   => 'www-data',
    require => [
      User['rubygems'],
      File['/var/www'],
    ]
  }

  user { 'rubygems' :
    ensure     => 'present',
    home       => '/var/lib/rubygems',
    comment    => 'Service used to run rubygems mirror synchronization',
    managehome => true,
    system     => true,
  }

  file { '/var/lib/rubygems/.gem' :
    ensure  => 'directory',
    owner   => 'rubygems',
    group   => 'rubygems',
    require => User['rubygems'],
  }

  file { '/var/lib/rubygems/.gem/.mirrorrc' :
    ensure  => 'present',
    owner   => 'rubygems',
    group   => 'rubygems',
    mode    => '0600',
    content => template('fuel_project/apps/rubygems_mirrorrc.erb'),
    replace => true,
    require => [
      User['rubygems'],
      File['/var/lib/rubygems/.gem'],
    ],
  }

  ::nginx::resource::vhost { $service_fqdn :
    ensure      => 'present',
    autoindex   => 'on',
    access_log  => $nginx_access_log,
    error_log   => $nginx_error_log,
    format_log  => $nginx_log_format,
    www_root    => $rubygems_dir,
    server_name => [$service_fqdn]
  }

  ::nginx::resource::location { 'rubygems_mirror_root' :
    ensure   => present,
    vhost    => $service_fqdn,
    www_root => $rubygems_dir,
  }

  file { '/var/run/rubygems' :
    ensure  => 'directory',
    owner   => 'rubygems',
    group   => 'root',
    require => User['rubygems'],
  }

  cron { 'rubygems-mirror' :
    minute      => $cron_frequency,
    command     => 'flock -n /var/run/rubygems/mirror.lock timeout -k 2m 30m gem mirror 2>&1 | logger -t rubygems-mirror',
    environment => 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    user        => 'rubygems',
  }

}
