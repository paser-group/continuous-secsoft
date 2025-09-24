# Used for deployment of TPI servers
class fuel_project::tpi::server (
) {
  class { '::fuel_project::common' :  }
  class { '::jenkins::master' :}

  class { 'rsync':
    package_ensure => 'present',
  }

  if (!defined(Class['::rsync::server'])) {
    class { '::rsync::server' :
      gid        => 'root',
      uid        => 'root',
      use_chroot => 'yes',
      use_xinetd => false,
    }
  }

  ::rsync::server::module{ 'storage':
    comment         => 'TPI main rsync share',
    uid             => 'nobody',
    gid             => 'nogroup',
    list            => 'yes',
    lock_file       => '/var/run/rsync_storage.lock',
    max_connections => 100,
    path            => '/storage',
    read_only       => 'yes',
    write_only      => 'no',
    incoming_chmod  => false,
    outgoing_chmod  => false,
  }

}
