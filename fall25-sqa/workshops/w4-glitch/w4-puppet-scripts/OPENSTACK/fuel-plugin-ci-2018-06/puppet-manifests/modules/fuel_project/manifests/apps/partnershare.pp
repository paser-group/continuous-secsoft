# Class: fuel_project::apps::partnershare
#
class fuel_project::apps::partnershare (
  $authorized_key,
  $htpasswd_content = '',
) {

  # used to download magnet links
  ensure_packages(['python-seed-client'])

  if (!defined(Class['::fuel_project::common'])) {
    class { '::fuel_project::common':
      external_host => $apply_firewall_rules,
    }
  }

  if (!defined(Class['::fuel_project::nginx'])) {
    class { '::fuel_project::nginx': }
  }

  user { 'partnershare':
    ensure     => 'present',
    home       => '/var/www/partnershare',
    managehome => true,
    system     => true,
    require    => File['/var/www'],
  }

  ssh_authorized_key { 'partnershare':
    user    => 'partnershare',
    type    => 'ssh-rsa',
    key     => $authorized_key,
    require => User['partnershare'],
  }

  file { '/etc/nginx/partners.htpasswd':
    ensure  => 'file',
    owner   => 'root',
    group   => 'www-data',
    mode    => '0640',
    content => $htpasswd_content,
  }

  cron { 'cleaner':
    command => 'find /var/www/partnershare -mtime +30 -delete > /dev/null 2>&1',
    user    => 'www-data',
    hour    => '*/1',
    minute  => '0',
  }

  ::nginx::resource::vhost { 'partnershare' :
    server_name      => ['share.fuel-infra.org'],
    www_root         => '/var/www/partnershare',
    vhost_cfg_append => {
      'autoindex'            => 'on',
      'auth_basic'           => '"Restricted access!"',
      'auth_basic_user_file' => '/etc/nginx/partners.htpasswd',
    }
  }

  ::nginx::resource::location { 'partnershare_root':
    ensure              => present,
    vhost               => 'partnershare',
    www_root            => '/var/www/partnershare',
    location            => '~ /\.',
    location_cfg_append => {
      deny => 'all',
    }
  }
}
