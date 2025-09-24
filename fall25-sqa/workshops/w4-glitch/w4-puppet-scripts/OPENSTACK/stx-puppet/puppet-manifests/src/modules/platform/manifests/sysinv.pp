class platform::sysinv::params (
  $api_port = 6385,
  $region_name = undef,
  $service_create = false,
  $fm_catalog_info = 'faultmanagement:fm:internalURL',
  $server_timeout = '600s',
) { }

class platform::sysinv
  inherits ::platform::sysinv::params {

  Anchor['platform::services'] -> Class[$name]

  include ::platform::params
  include ::platform::amqp::params
  include ::platform::drbd::platform::params

  # sysinv-agent is started on all hosts
  include ::sysinv::agent

  $keystone_key_repo_path = "${::platform::drbd::platform::params::mountpoint}/keystone"

  group { 'sysinv':
    ensure => 'present',
    gid    => '168',
  }

  -> user { 'sysinv':
    ensure           => 'present',
    comment          => 'sysinv Daemons',
    gid              => '168',
    groups           => ['nobody', 'sysinv', 'sys_protected'],
    home             => '/var/lib/sysinv',
    password         => '!!',
    password_max_age => '-1',
    password_min_age => '-1',
    shell            => '/sbin/nologin',
    uid              => '168',
  }

  -> file { '/etc/sysinv':
    ensure => 'directory',
    owner  => 'sysinv',
    group  => 'sysinv',
    mode   => '0750',
  }

  -> class { '::sysinv':
    rabbit_host           => $::platform::amqp::params::host_url,
    rabbit_port           => $::platform::amqp::params::port,
    rabbit_userid         => $::platform::amqp::params::auth_user,
    rabbit_password       => $::platform::amqp::params::auth_password,
    fm_catalog_info       => $fm_catalog_info,
    fernet_key_repository => "${keystone_key_repo_path}/fernet-keys",
  }

  # Note: The log format strings are prefixed with "sysinv" because it is
  # interpreted as the program by syslog-ng, which allows the sysinv logs to be
  # filtered and directed to their own file.

  # TODO(mpeters): update puppet-sysinv to permit configuration of log formats
  # once the log configuration has been moved to oslo::log
  sysinv_config {
    'DEFAULT/logging_context_format_string': value =>
      'sysinv %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user)s %(tenant)s] %(instance)s%(message)s';
    'DEFAULT/logging_default_format_string': value =>
      'sysinv %(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s';
  }
}


class platform::sysinv::conductor {

  Class['::platform::drbd::platform'] -> Class[$name]

  include ::sysinv::conductor
}


class platform::sysinv::haproxy
  inherits ::platform::sysinv::params {
  include ::platform::params
  include ::platform::haproxy::params

  platform::haproxy::proxy { 'sysinv-restapi':
    server_name    => 's-sysinv',
    public_port    => $api_port,
    private_port   => $api_port,
    server_timeout => $server_timeout,
  }

  # Configure rules for DC https enabled admin endpoint.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    platform::haproxy::proxy { 'sysinv-restapi-admin':
      https_ep_type     => 'admin',
      server_name       => 's-sysinv',
      public_ip_address => $::platform::haproxy::params::private_ip_address,
      public_port       => $api_port + 1,
      private_port      => $api_port,
      server_timeout    => $server_timeout,
    }
  }
}


class platform::sysinv::api
  inherits ::platform::sysinv::params {

  include ::platform::params
  include ::sysinv::api

  if ($::platform::sysinv::params::service_create and
      $::platform::params::init_keystone) {
    include ::sysinv::keystone::auth

    # Cleanup the endpoints created at bootstrap if they are not in
    # the subcloud region.
    if ($::platform::params::distributed_cloud_role == 'subcloud' and
        $::platform::params::region_2_name != 'RegionOne') {
      Keystone_endpoint["${platform::params::region_2_name}/sysinv::platform"] -> Keystone_endpoint['RegionOne/sysinv::platform']
      keystone_endpoint { 'RegionOne/sysinv::platform':
        ensure       => 'absent',
        name         => 'sysinv',
        type         => 'platform',
        region       => 'RegionOne',
        public_url   => 'http://127.0.0.1:6385/v1',
        admin_url    => 'http://127.0.0.1:6385/v1',
        internal_url => 'http://127.0.0.1:6385/v1'
      }
    }
  }

  # TODO(mpeters): move to sysinv puppet module parameters
  sysinv_config {
    'DEFAULT/sysinv_api_workers': value => $::platform::params::eng_workers_by_5;
  }

  include ::platform::sysinv::haproxy
}


class platform::sysinv::bootstrap (
  $dc_sysinv_user_id = undef,
) {
  include ::sysinv::db::postgresql
  include ::sysinv::keystone::auth

  if $dc_sysinv_user_id {
    exec { 'update keystone sysinv assignment actor_id to match system controller':
      command => "psql -d keystone -c \"update public.assignment set actor_id='${dc_sysinv_user_id}' from public.local_user where\
                  public.assignment.actor_id=public.local_user.user_id and public.local_user.name='sysinv'\"",
      user    => 'postgres',
      require => Class['::sysinv::keystone::auth'],
    }
    -> exec { 'update keystone sysinv user id to match system controller':
      command => "psql -d keystone -c \"update public.user set id='${dc_sysinv_user_id}' from public.local_user where\
                  public.user.id=public.local_user.user_id and public.local_user.name='sysinv'\"",
      user    => 'postgres',
    }
  }

  include ::platform::sysinv

  class { '::sysinv::api':
    enabled => true
  }

  class { '::sysinv::conductor':
    enabled => true
  }
}
