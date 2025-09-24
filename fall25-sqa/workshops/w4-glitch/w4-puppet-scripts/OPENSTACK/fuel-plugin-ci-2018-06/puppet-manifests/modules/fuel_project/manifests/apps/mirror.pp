# Class: fuel_project::apps::mirror
#
class fuel_project::apps::mirror (
  $autoindex                = 'on',
  $dir                      = '/var/www/mirror',
  $dir_group                = 'www-data',
  $dir_owner                = 'www-data',
  $firewall_allow_sources   = {},
  $nginx_access_log         = '/var/log/nginx/access.log',
  $nginx_error_log          = '/var/log/nginx/error.log',
  $nginx_log_format         = 'proxy',
  $port                     = 80,
  $rsync_mirror_lockfile    = '/var/run/rsync_mirror.lock',
  $rsync_mirror_lockfile_rw = '/var/run/rsync_mirror_sync.lock',
  $rsync_rw_share_comment   = 'Fuel mirror sync',
  $rsync_share_comment      = 'Fuel mirror rsync share',
  $rsync_writable_share     = true,
  $service_aliases          = [],
  $service_fqdn             = "mirror.${::fqdn}",
  $sync_hosts_allow         = [],
) {
  if(!defined(Class['rsync'])) {
    class { 'rsync' :
      package_ensure => 'present',
    }
  }

  ensure_resource('user', $dir_owner, {
    ensure     => 'present',
  })

  ensure_resource('group', $dir_group, {
    ensure     => 'present',
  })

  file { $dir :
    ensure  => 'directory',
    owner   => $dir_owner,
    group   => $dir_group,
    mode    => '0755',
    require => [
        Class['nginx'],
        User[$dir_owner],
        Group[$dir_group],
      ],
  }

  if (!defined(Class['::rsync::server'])) {
    class { '::rsync::server' :
      gid        => 'root',
      uid        => 'root',
      use_chroot => 'yes',
      use_xinetd => false,
    }
  }

  ::rsync::server::module{ 'mirror':
    comment         => $rsync_share_comment,
    uid             => 'nobody',
    gid             => 'nogroup',
    list            => 'yes',
    lock_file       => $rsync_mirror_lockfile,
    max_connections => 100,
    path            => $dir,
    read_only       => 'yes',
    write_only      => 'no',
    require         => File[$dir],
  }

  if ($rsync_writable_share) {
    ::rsync::server::module{ 'mirror-sync':
      comment         => $rsync_rw_share_comment,
      uid             => $dir_owner,
      gid             => $dir_group,
      hosts_allow     => $sync_hosts_allow,
      hosts_deny      => ['*'],
      incoming_chmod  => '0755',
      outgoing_chmod  => '0644',
      list            => 'yes',
      lock_file       => $rsync_mirror_lockfile_rw,
      max_connections => 100,
      path            => $dir,
      read_only       => 'no',
      write_only      => 'no',
      require         => [
          File[$dir],
          User[$dir_owner],
          Group[$dir_group],
        ],
    }
  }

  if (!defined(Class['::fuel_project::nginx'])) {
    class { '::fuel_project::nginx' :}
  }
  ::nginx::resource::vhost { 'mirror' :
    ensure              => 'present',
    www_root            => $dir,
    access_log          => $nginx_access_log,
    error_log           => $nginx_error_log,
    format_log          => $nginx_log_format,
    server_name         => [
      $service_fqdn,
      "mirror.${::fqdn}",
      join($service_aliases, ' ')
    ],
    location_cfg_append => {
      autoindex => $autoindex,
    },
  }
}
