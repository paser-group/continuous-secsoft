class manila_auxiliary::services (
  ) {
  if roles_include(['controller', 'primary-controller']) {
    exec { 'manual_db_sync':
      command => 'manila-manage db sync',
      path    => '/usr/bin',
      user    => 'manila',
      }->
      service { 'manila-api':
        ensure    => 'running',
        name      => 'manila-api',
        enable    => true,
        hasstatus => true,
        }->
        service { 'manila-scheduler':
          ensure    => 'running',
          name      => 'manila-scheduler',
          enable    => true,
          hasstatus => true,
        }

        } elsif roles_include(['manila-share']) {
        service { 'manila-share':
          ensure    => 'running',
          name      => 'manila-share',
          enable    => true,
          hasstatus => true,
        }

        } elsif roles_include(['manila-data']) {
        service {'manila-data':
          ensure => 'running',
          name   => 'manila-data',
          enable    => true,
          hasstatus => true,
        }
        }
  }
