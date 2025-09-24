# Class: fuel_project::apps::plugins
#
class fuel_project::apps::plugins (
  $apply_firewall_rules   = false,
  $firewall_allow_sources = {},
  $nginx_access_log       = '/var/log/nginx/access.log',
  $nginx_error_log        = '/var/log/nginx/error.log',
  $nginx_log_format       = 'proxy',
  $plugins_dir            = '/var/www/plugins',
  $service_fqdn           = "plugins.${::fqdn}",
  $sync_hosts_allow       = [],
) {
  if (!defined(Class['::fuel_project::nginx'])) {
    class { '::fuel_project::nginx' :}
  }
  ::nginx::resource::vhost { 'plugins' :
    ensure      => 'present',
    autoindex   => 'on',
    access_log  => $nginx_access_log,
    error_log   => $nginx_error_log,
    format_log  => $nginx_log_format,
    www_root    => $plugins_dir,
    server_name => [$service_fqdn, "plugins.${::fqdn}"]
  }

  file { $plugins_dir :
    ensure  => 'directory',
    owner   => 'www-data',
    group   => 'www-data',
    require => Class['::nginx'],
  }

  if (!defined(Class['::rsync::server'])) {
    class { '::rsync::server' :
      gid        => 'root',
      uid        => 'root',
      use_chroot => 'yes',
      use_xinetd => false,
    }
  }

  ::rsync::server::module{ 'plugins':
    comment         => 'Fuel plugins sync',
    uid             => 'www-data',
    gid             => 'www-data',
    hosts_allow     => $sync_hosts_allow,
    hosts_deny      => ['*'],
    incoming_chmod  => '0755',
    outgoing_chmod  => '0644',
    list            => 'yes',
    lock_file       => '/var/run/rsync_plugins_sync.lock',
    max_connections => 100,
    path            => $plugins_dir,
    read_only       => 'no',
    write_only      => 'no',
    require         => File[$plugins_dir],
  }
}
