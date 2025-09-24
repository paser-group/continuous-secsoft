# Class: fuel_project::apps::update
#
class fuel_project::apps::updates (
  $apply_firewall_rules   = false,
  $firewall_allow_sources = {},
  $nginx_access_log       = '/var/log/nginx/access.log',
  $nginx_error_log        = '/var/log/nginx/error.log',
  $nginx_log_format       = 'proxy',
  $service_fqdn           = "updates.${::fqdn}",
  $sync_hosts_allow       = [],
  $updates_dir            = '/var/www/updates',
) {
  if (!defined(Class['::fuel_project::nginx'])) {
    class { '::fuel_project::nginx' :}
  }
  ::nginx::resource::vhost { 'updates' :
    ensure      => 'present',
    autoindex   => 'on',
    access_log  => $nginx_access_log,
    error_log   => $nginx_error_log,
    format_log  => $nginx_log_format,
    www_root    => $updates_dir,
    server_name => [$service_fqdn, "updates.${::fqdn}"]
  }

  file { $updates_dir :
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

  ::rsync::server::module{ 'updates':
    comment         => 'Fuel updates sync',
    uid             => 'www-data',
    gid             => 'www-data',
    hosts_allow     => $sync_hosts_allow,
    hosts_deny      => ['*'],
    incoming_chmod  => '0755',
    outgoing_chmod  => '0644',
    list            => 'yes',
    lock_file       => '/var/run/rsync_updates_sync.lock',
    max_connections => 100,
    path            => $updates_dir,
    read_only       => 'no',
    write_only      => 'no',
    require         => File[$updates_dir],
  }
}
