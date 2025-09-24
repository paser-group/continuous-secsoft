class platform::mtce::params (
  $auth_host = undef,
  $auth_port = undef,
  $auth_uri = undef,
  $auth_username = undef,
  $auth_pw = undef,
  $auth_project = undef,
  $auth_user_domain = undef,
  $auth_project_domain = undef,
  $auth_region = undef,
  $worker_boot_timeout = 720,
  $controller_boot_timeout = 1200,
  $heartbeat_degrade_threshold = 6,
  $heartbeat_failure_threshold = 10,
  $heartbeat_failure_action = 'fail',
  $heartbeat_period = 100,
  $mtce_multicast = undef,
  $mnfa_threshold = 2,
  $mnfa_timeout = 0,
  $bmc_access_method = 'learn',
  $sm_client_port = 2224,
  $sm_server_port = 2124,
) { }


class platform::mtce
  inherits ::platform::mtce::params {

  include ::platform::client::credentials::params
  $keyring_directory = $::platform::client::credentials::params::keyring_directory

  file { '/etc/mtc.ini':
    ensure  => present,
    mode    => '0600',
    content => template('mtce/mtc_ini.erb'),
  }

  $boot_device = $::boot_disk_device_path
}


class platform::mtce::agent
  inherits ::platform::mtce::params {

  if $::platform::params::init_keystone {
    # configure a mtce keystone user
    keystone_user { $auth_username:
      ensure   => present,
      password => $auth_pw,
      enabled  => true,
    }

    # assign an admin role for this mtce user on the services tenant
    keystone_user_role { "${auth_username}@${auth_project}":
      ensure         => present,
      user_domain    => $auth_user_domain,
      project_domain => $auth_project_domain,
      roles          => ['admin'],
    }
  }
}


class platform::mtce::reload {
  exec {'signal-mtc-agent':
    command => 'pkill -HUP mtcAgent',
  }
  exec {'signal-hbs-agent':
    command => 'pkill -HUP hbsAgent',
  }

  # mtcClient and hbsClient don't currently reload all configuration,
  # therefore they must be restarted.  Move to HUP if daemon updated.
  exec {'pmon-restart-hbs-client':
    command => 'pmon-restart hbsClient',
  }
  exec {'pmon-restart-mtc-client':
    command => 'pmon-restart mtcClient',
  }
}

class platform::mtce::runtime {
  include ::platform::mtce

  class {'::platform::mtce::reload':
    stage => post
  }
}

class platform::mtce::bootstrap
  inherits ::platform::mtce::params {

  include ::platform::params
  include ::platform::mtce

  # configure a mtce keystone user
  keystone_user { $auth_username:
    ensure   => present,
    password => $auth_pw,
    enabled  => true,
  }

  # assign an admin role for this mtce user on the services tenant
  keystone_user_role { "${auth_username}@${auth_project}":
    ensure         => present,
    user_domain    => $auth_user_domain,
    project_domain => $auth_project_domain,
    roles          => ['admin'],
  }
}
