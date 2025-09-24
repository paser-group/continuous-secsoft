# Class: fuel_project::apps::mirror_pypi
#
class fuel_project::apps::mirror_pypi (
  $cron_frequency         = '*/5',
  $mirror_delete_packages = true,
  $mirror_dir             = '/var/www/pypi_mirror',
  $mirror_master          = 'https://pypi.python.org',
  $mirror_stop_on_error   = true,
  $mirror_timeout         = 10,
  $mirror_workers         = 5,
  $nginx_access_log       = '/var/log/nginx/access.log',
  $nginx_error_log        = '/var/log/nginx/error.log',
  $nginx_log_format       = 'proxy',
  $service_fqdn           = $::fqdn,
) {

  validate_bool(
    $mirror_delete_packages,
    $mirror_stop_on_error,
  )

  $packages = [
    'python-bandersnatch-wrapper',
    'python-pip',
  ]

  ensure_packages($packages)

  package { 'bandersnatch' :
    ensure   => '1.8',
    provider => pip,
    require  => Package[$packages],
  }

  ensure_resource('file', '/var/www', {
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  })

  file { $mirror_dir :
    ensure  => 'directory',
    owner   => 'pypi',
    group   => 'www-data',
    require => [
      User['pypi'],
      File['/var/www'],
    ]
  }

  user { 'pypi' :
    ensure     => 'present',
    home       => '/var/lib/pypi',
    comment    => 'Service used to run pypi mirror synchronization',
    managehome => true,
    system     => true,
  }

  file { '/etc/bandersnatch.conf' :
    ensure  => 'present',
    owner   => 'pypi',
    group   => 'pypi',
    mode    => '0600',
    content => template('fuel_project/apps/bandersnatch.conf.erb'),
    require => [
      User['pypi'],
      Package[$packages],
    ]
  }

  # Configure webserver to serve the web/ sub-directory of the mirror.
  ::nginx::resource::vhost { $service_fqdn :
    ensure           => 'present',
    autoindex        => 'on',
    access_log       => $nginx_access_log,
    error_log        => $nginx_error_log,
    format_log       => $nginx_log_format,
    www_root         => "${mirror_dir}/web",
    server_name      => [$service_fqdn],
    vhost_cfg_append => {
      charset => 'utf-8',
    }
  }

  ::nginx::resource::location { 'pypi_mirror_root' :
    ensure   => 'present',
    vhost    => $service_fqdn,
    www_root => "${mirror_dir}/web",
  }

  file { '/var/run/bandersnatch' :
    ensure  => 'directory',
    owner   => 'pypi',
    group   => 'root',
    require => [
      User['pypi'],
      Package[$packages],
    ]
  }

  cron { 'pypi-mirror' :
    minute      => $cron_frequency,
    command     => 'flock -n /var/run/bandersnatch/mirror.lock timeout -k 2m 30m /usr/bin/run-bandersnatch 2>&1 | logger -t pypi-mirror',
    user        => 'pypi',
    environment => 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    require     => [
      User['pypi'],
      Package[$packages],
    ]
  }

}
