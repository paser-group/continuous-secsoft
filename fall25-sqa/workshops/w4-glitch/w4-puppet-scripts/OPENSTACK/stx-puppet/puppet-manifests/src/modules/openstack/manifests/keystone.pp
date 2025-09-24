class openstack::keystone::params(
  $api_version,
  $identity_uri,
  $auth_uri,
  $host_url,
  $openstack_auth_uri = undef,
  $api_port = 5000,
  $admin_port = 5000,
  $region_name = undef,
  $system_controller_region = undef,
  $service_name = 'openstack-keystone',
  $token_expiration = 3600,
  $service_create = false,
  $fernet_keys_rotation_minute = '25',
  $fernet_keys_rotation_hour = '0',
  $fernet_keys_rotation_month = '*/1',
  $fernet_keys_rotation_monthday = '1',
  $fernet_keys_rotation_weekday = '*',
) {}

class openstack::keystone (
) inherits ::openstack::keystone::params {

  include ::platform::params

  # In the case of a classical Multi-Region deployment, apply the Keystone
  # controller configuration for Primary Region ONLY
  # (i.e. on which region_config is False), since Keystone is a Shared service
  #
  # In the case of a Distributed Cloud deployment, apply the Keystone
  # controller configuration for each SubCloud, since Keystone is also
  # a localized service.
  if (!$::platform::params::region_config or
      $::platform::params::distributed_cloud_role == 'subcloud')  {
    include ::platform::amqp::params
    include ::platform::network::mgmt::params
    include ::platform::drbd::platform::params

    $keystone_key_repo_path = "${::platform::drbd::platform::params::mountpoint}/keystone"
    $eng_workers = $::platform::params::eng_workers
    $enabled = false
    $bind_host = $::platform::network::mgmt::params::controller_address_url

    Class[$name] -> Class['::platform::client']

    include ::keystone::client


    # Configure keystone graceful shutdown timeout
    # TODO(mpeters): move to puppet-keystone for module configuration
    keystone_config {
      'DEFAULT/graceful_shutdown_timeout': value => 15;
    }

    # (Pike Rebase) Disable token post expiration window since this
    # allows authentication for upto 2 days worth of stale tokens.
    # TODO(knasim): move this to puppet-keystone along with graceful
    # shutdown timeout param
    keystone_config {
        'token/allow_expired_window': value => 0;
    }

    keystone_config {
        'security_compliance/lockout_duration': value => 1800;
        'security_compliance/lockout_failure_attempts': value => 5;
    }

    file { '/etc/keystone/keystone-extra.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'keystone',
      mode    => '0640',
      content => template('openstack/keystone-extra.conf.erb'),
    }
    -> class { '::keystone':
      enabled               => $enabled,
      enable_fernet_setup   => false,
      fernet_key_repository => "${keystone_key_repo_path}/fernet-keys",
      default_transport_url => $::platform::amqp::params::transport_url,
      service_name          => $service_name,
      token_expiration      => $token_expiration,
      notification_driver   => 'messagingv2',
    }
    # remove admin_token from keystone.conf
    -> ini_setting { 'remove admin_token in config':
      ensure  => absent,
      path    => '/etc/keystone/keystone.conf',
      section => 'DEFAULT',
      setting => 'admin_token',
    }

    # create keystone policy configuration
    file { '/etc/keystone/policy.json':
      ensure  => present,
      owner   => 'keystone',
      group   => 'keystone',
      mode    => '0640',
      content => template('openstack/keystone-policy.json.erb'),
    }

    # Keystone users can only be added to the SQL backend (write support for
    # the LDAP backend has been removed). We can therefore set password rules
    # irrespective of the backend
    if ! str2bool($::is_restore_in_progress) {
      # If the Restore is in progress then we need to apply the Keystone
      # Password rules as a runtime manifest, as the passwords in the hiera records
      # records may not be rule-compliant if this system was upgraded from R4
      # (where-in password rules were not in affect)
      include ::keystone::security_compliance
    }

    include ::keystone::ldap

    if $::platform::params::distributed_cloud_role == undef {
      # Set up cron job that will rotate fernet keys. This is done every month on
      # the first day of the month at 00:25 by default. The cron job runs on both
      # controllers, but the script will only take action on the active controller.
      cron { 'keystone-fernet-keys-rotater':
        ensure      => 'present',
        command     => '/usr/bin/keystone-fernet-keys-rotate-active',
        environment => 'PATH=/bin:/usr/bin:/usr/sbin',
        minute      => $fernet_keys_rotation_minute,
        hour        => $fernet_keys_rotation_hour,
        month       => $fernet_keys_rotation_month,
        monthday    => $fernet_keys_rotation_monthday,
        weekday     => $fernet_keys_rotation_weekday,
        user        => 'root',
      }
    }
  } else {
      class { '::keystone':
        enabled          => false,
      }
  }
}

class openstack::keystone::haproxy
  inherits ::openstack::keystone::params {

  include ::platform::params
  include ::platform::haproxy::params

  platform::haproxy::proxy { 'keystone-restapi':
    server_name  => 's-keystone',
    public_port  => $api_port,
    private_port => $api_port,
  }

  # Configure rules for DC https enabled admin endpoint.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    platform::haproxy::proxy { 'keystone-restapi-admin':
      https_ep_type     => 'admin',
      server_name       => 's-keystone',
      public_ip_address => $::platform::haproxy::params::private_ip_address,
      public_port       => $api_port + 1,
      private_port      => $api_port,
    }
  }
}

define delete_endpoints (
  $region,
  $service,
  $interfaces,
) {
  $rc_file = '/etc/platform/openrc'
  $delete_endpoint = 'openstack endpoint delete'
  $interfaces.each | String $val | {
    $get_endpoint_id = "openstack endpoint list --region ${region} --service ${service} --interface ${val} -f value -c ID"
    exec { "Delete ${region} ${service} ${val} endpoint":
      command   => "source ${rc_file} && ${get_endpoint_id} | xargs -r ${delete_endpoint}",
      logoutput => true,
      provider  => shell,
    }
  }
}

define openstack::keystone::user::option (
  $admin_username,
  $admin_password,
  $auth_url,
  $username,
  $option,
  String $option_value,
) {
  exec { "Set user ${username} option ${option} to ${option_value}":
    command   => @("EOC"/L),
      /usr/local/bin/set_keystone_user_option.sh \
      ${admin_username} ${admin_password} ${auth_url} ${username} ${option} ${option_value}
      | EOC
    logoutput => true,
    provider  => shell,
  }
}

class openstack::keystone::api
  inherits ::openstack::keystone::params {

  include ::platform::params

  if ($::openstack::keystone::params::service_create and
      $::platform::params::init_keystone) {
    include ::keystone::endpoint
    include ::openstack::keystone::endpointgroup

    # Cleanup the endpoints created at bootstrap if they are not in
    # the subcloud region.
    if ($::platform::params::distributed_cloud_role == 'subcloud' and
        $::platform::params::region_2_name != 'RegionOne') {
      $interfaces = [ 'public', 'internal', 'admin' ]
      Keystone_endpoint<||> -> Class['::platform::client']
      # clean up the bootstrap endpoints
      -> delete_endpoints { 'Start delete endpoints':
        region     => 'RegionOne',
        service    => 'keystone',
        interfaces => $interfaces,
      }
    }
  }

  include ::openstack::keystone::haproxy
}


class openstack::keystone::bootstrap(
  $default_domain = 'Default',
  $dc_services_project_id = undef,
) {
  include ::platform::params
  include ::platform::amqp::params
  include ::platform::drbd::platform::params
  include ::platform::client::params

  $keystone_key_repo_path = "${::platform::drbd::platform::params::mountpoint}/keystone"
  $eng_workers = $::platform::params::eng_workers
  $bind_host = '[::]'

  # In the case of a classical Multi-Region deployment, apply the Keystone
  # controller configuration for Primary Region ONLY
  # (i.e. on which region_config is False), since Keystone is a Shared service
  #
  # In the case of a Distributed Cloud deployment, apply the Keystone
  # controller configuration for each SubCloud, since Keystone is also
  # a localized service.

  if (!$::platform::params::region_config or
      $::platform::params::distributed_cloud_role == 'subcloud') {

    include ::keystone::db::postgresql

    Class[$name] -> Class['::platform::client']

    # Create the parent directory for fernet keys repository
    file { $keystone_key_repo_path:
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Class['::platform::drbd::platform'],
    }
    -> file { '/etc/keystone/keystone-extra.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'keystone',
      mode    => '0640',
      content => template('openstack/keystone-extra.conf.erb'),
    }
    -> class { '::keystone':
      enabled               => true,
      enable_bootstrap      => true,
      fernet_key_repository => "${keystone_key_repo_path}/fernet-keys",
      sync_db               => true,
      default_domain        => $default_domain,
      default_transport_url => $::platform::amqp::params::transport_url,
    }

    include ::keystone::client
    include ::keystone::endpoint
    include ::keystone::roles::admin

    # Ensure the default _member_ role is present
    keystone_role { '_member_':
      ensure => present,
    }

    # disabling the admin token per openstack recommendation
    include ::keystone::disable_admin_token_auth

    if $dc_services_project_id {
      exec { 'update keystone assignment target id for services to match system controller':
        command => "psql -d keystone -c \"update public.assignment set target_id='${dc_services_project_id}' from public.project where\
                    public.assignment.target_id=public.project.id and public.project.name='services'\"",
        user    => 'postgres',
        # keystone interleaves creation of users, projects, roles and assignments and internally caches ids so we have to wait until all the
        # users of services project are completed before we can manipulate the database entries
        require => [ Class['::keystone::roles::admin'],
                    Class['::openstack::barbican::bootstrap'],
                    Class['::platform::sysinv::bootstrap'],
                    Class['::platform::mtce::bootstrap'],
                    Class['::platform::fm::bootstrap'],
                    Class['::platform::dcmanager::bootstrap']],
      }
      -> exec { 'update keystone services project id to match system controller':
        command => "psql -d keystone -c \"update public.project set id='${dc_services_project_id}' where name='services'\"",
        user    => 'postgres',
      }
    }

    # set admin ignore_lockout_failure_attempts option to true to exempt
    # admin user from auth fail lockout.
    Keystone::Resource::Service_identity <||>
    -> openstack::keystone::user::option { 'Set user option':
      admin_username => $::platform::client::params::admin_username,
      admin_password => $::platform::client::params::admin_password,
      auth_url       => $::platform::client::params::identity_auth_url,
      username       => $::platform::client::params::admin_username,
      option         => 'ignore_lockout_failure_attempts',
      option_value   => bool2str(true),
    }
  }
}


class openstack::keystone::reload {
  platform::sm::restart {'keystone': }
}


class openstack::keystone::endpointgroup
  inherits ::openstack::keystone::params {
  include ::platform::params
  include ::platform::client

  # $::platform::params::init_keystone should be checked by the caller.
  # as this class should be only invoked when initializing keystone.

  if ($::platform::params::distributed_cloud_role =='systemcontroller') {
    $reference_region = $::openstack::keystone::params::region_name
    $system_controller_region = $::openstack::keystone::params::system_controller_region
    $os_username = $::platform::client::params::admin_username
    $identity_region = $::platform::client::params::identity_region
    $keystone_region = $::platform::client::params::keystone_identity_region
    $keyring_file = $::platform::client::credentials::params::keyring_file
    $auth_url = $::platform::client::params::identity_auth_url
    $os_project_name = $::platform::client::params::admin_project_name
    $api_version = 3

    file { "/etc/keystone/keystone-${reference_region}-filter.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'keystone',
      mode    => '0640',
      content => template('openstack/keystone-defaultregion-filter.erb'),
    }
    -> file { "/etc/keystone/keystone-${system_controller_region}-filter.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'keystone',
      mode    => '0640',
      content => template('openstack/keystone-systemcontroller-filter.erb'),
    }
    -> exec { "endpointgroup-${reference_region}-command":
      cwd       => '/etc/keystone',
      logoutput => true,
      provider  => shell,
      require   => [ Class['openstack::keystone::api'], Class['::keystone::endpoint'] ],
      command   => template('openstack/keystone-defaultregion.erb'),
      path      =>  ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin/'],
    }
    -> exec { "endpointgroup-${system_controller_region}-command":
      cwd       => '/etc/keystone',
      logoutput => true,
      provider  => shell,
      require   => [ Class['openstack::keystone::api'], Class['::keystone::endpoint'] ],
      command   => template('openstack/keystone-systemcontroller.erb'),
      path      =>  ['/usr/bin/', '/bin/', '/sbin/', '/usr/sbin/'],
    }
  }
}


class openstack::keystone::server::runtime {
  include ::platform::client
  include ::openstack::keystone

  class {'::openstack::keystone::reload':
    stage => post
  }
}


class openstack::keystone::endpoint::runtime {

  if str2bool($::is_controller_active) {
    include ::keystone::endpoint

    include ::sysinv::keystone::auth
    include ::patching::keystone::auth
    include ::nfv::keystone::auth
    include ::fm::keystone::auth
    include ::barbican::keystone::auth

    if $::platform::params::distributed_cloud_role =='systemcontroller' {
      include ::dcorch::keystone::auth
      include ::dcmanager::keystone::auth
      include ::dcdbsync::keystone::auth
    }

    if $::platform::params::distributed_cloud_role == 'subcloud' {
      include ::dcdbsync::keystone::auth
    }

    include ::smapi::keystone::auth

    if ($::platform::params::distributed_cloud_role == 'subcloud' and
        $::platform::params::region_2_name != 'RegionOne') {
      $interfaces = [ 'public', 'internal', 'admin' ]
      include ::platform::client
      # Cleanup the endpoints created at bootstrap if they are not in
      # the subcloud region.
      Keystone::Resource::Service_identity <||>
      -> Class['::platform::client']
      -> delete_endpoints { 'Delete keystone endpoints':
        region     => 'RegionOne',
        service    => 'keystone',
        interfaces => $interfaces,
      }
      -> delete_endpoints { 'Delete sysinv endpoints':
        region     => 'RegionOne',
        service    => 'sysinv',
        interfaces => $interfaces,
      }
      -> delete_endpoints { 'Delete barbican endpoints':
        region     => 'RegionOne',
        service    => 'barbican',
        interfaces => $interfaces,
      }
      -> delete_endpoints { 'Delete fm endpoints':
        region     => 'RegionOne',
        service    => 'fm',
        interfaces => $interfaces,
      }
      -> file { '/etc/platform/.service_endpoint_reconfigured':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    } else {
      Keystone::Resource::Service_identity <||>
      -> file { '/etc/platform/.service_endpoint_reconfigured':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }

  }
}

class openstack::keystone::upgrade (
  $upgrade_token_cmd,
  $upgrade_url = undef,
  $upgrade_token_file = undef,
) {

  if $::platform::params::init_keystone {
    include ::keystone::db::postgresql
    include ::platform::params
    include ::platform::amqp::params
    include ::platform::network::mgmt::params
    include ::platform::drbd::platform::params

    # the unit address is actually the configured default of the loopback address.
    $bind_host = $::platform::network::mgmt::params::controller0_address
    $eng_workers = $::platform::params::eng_workers

    $keystone_key_repo = "${::platform::drbd::platform::params::mountpoint}/keystone"

    # Need to create the parent directory for fernet keys repository
    # This is a workaround to a puppet bug.
    file { $keystone_key_repo:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755'
    }
    -> file { '/etc/keystone/keystone-extra.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'keystone',
      mode    => '0640',
      content => template('openstack/keystone-extra.conf.erb'),
    }
    -> class { '::keystone':
      upgrade_token_cmd     => $upgrade_token_cmd,
      upgrade_token_file    => $upgrade_token_file,
      enable_fernet_setup   => true,
      enable_bootstrap      => false,
      fernet_key_repository => "${keystone_key_repo}/fernet-keys",
      sync_db               => false,
      default_domain        => undef,
      default_transport_url => $::platform::amqp::params::transport_url,
    }

    # Add service account and endpoints for any new R6 services...
    # include ::<new service>::keystone::auth
    # No new services yet...

    # Always remove the upgrade token file after all new
    # services have been added
    file { $upgrade_token_file :
      ensure => absent,
    }

    include ::keystone::client
  }

}
