# Class: fuel_project::apps::web_share
#
class fuel_project::apps::web_share (
  $authorized_keys,
  $group             = 'jenkins',
  $nginx_access_log  = '/var/log/nginx/access.log',
  $nginx_autoindex   = 'on',
  $nginx_error_log   = '/var/log/nginx/error.log',
  $nginx_log_format  = undef,
  $nginx_server_name = $::fqdn,
  $share_root        = '/var/www/share_logs',
  $user              = 'jenkins',
) {

  ensure_resource('file', '/var/www', {
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  })

  file { $share_root :
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => [
      User[$user],
      File['/var/www'],
    ],
  }

  ::nginx::resource::vhost { 'share-http' :
    ensure      => 'present',
    server_name => [$nginx_server_name],
    listen_port => 80,
    www_root    => $share_root,
    access_log  => $nginx_access_log,
    error_log   => $nginx_error_log,
    format_log  => $nginx_log_format,
    autoindex   => $nginx_autoindex,
    require     => File[$share_root],
  }

  # manage user $HOME manually, since we don't need .bash* stuff
  # but only ~/.ssh/
  file { "/var/lib/${user}" :
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  user { $user :
    ensure     => 'present',
    system     => true,
    managehome => false,
    home       => "/var/lib/${user}",
    shell      => '/usr/sbin/nologin',
  }

  create_resources(ssh_authorized_key, $authorized_keys, {
    ensure  => 'present',
    user    => $user,
    require => [
      User[$user],
    ],
  })

}
