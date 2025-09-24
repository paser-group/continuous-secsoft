class platform::fm::params (
  $api_port = 18002,
  $api_host = '127.0.0.1',
  $region_name = undef,
  $system_name = undef,
  $service_create = false,
  $service_enabled = true,
  $sysinv_catalog_info = 'platform:sysinv:internalURL',
  $snmp_enabled = 0,
  $snmp_trap_server_port = 162,
) { }


class platform::fm::config
  inherits ::platform::fm::params {

  class { '::fm':
    region_name           => $region_name,
    system_name           => $system_name,
    sysinv_catalog_info   => $sysinv_catalog_info,
    snmp_enabled          => $snmp_enabled,
    snmp_trap_server_port => $snmp_trap_server_port,
  }
}

class platform::fm
  inherits ::platform::fm::params {

  include ::fm::client
  include ::fm::keystone::authtoken
  include ::platform::fm::config

  include ::platform::params
  if $::platform::params::init_database {
    include ::fm::db::postgresql
  }
}

class platform::fm::haproxy
  inherits ::platform::fm::params {

  include ::platform::params
  include ::platform::haproxy::params

  platform::haproxy::proxy { 'fm-api-internal':
    server_name        => 's-fm-api-internal',
    public_ip_address  => $::platform::haproxy::params::private_ip_address,
    public_port        => $api_port,
    private_ip_address => $api_host,
    private_port       => $api_port,
    public_api         => false,
  }

  platform::haproxy::proxy { 'fm-api-public':
    server_name  => 's-fm-api-public',
    public_port  => $api_port,
    private_port => $api_port,
  }

  # Configure rules for DC https enabled admin endpoint.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    platform::haproxy::proxy { 'fm-api-admin':
      https_ep_type     => 'admin',
      server_name       => 's-fm-api-admin',
      public_ip_address => $::platform::haproxy::params::private_ip_address,
      public_port       => $api_port + 1,
      private_port      => $api_port,
    }
  }
}

class platform::fm::api
  inherits ::platform::fm::params {

  include ::platform::params

  if $service_enabled {
    if ($::platform::fm::service_create and
        $::platform::params::init_keystone) {
      include ::fm::keystone::auth
    }

    include ::platform::params

    class { '::fm::api':
      host    => $api_host,
      workers => $::platform::params::eng_workers,
      sync_db => $::platform::params::init_database,
    }

    include ::platform::fm::haproxy
  }
}

class platform::fm::runtime {

  require ::platform::fm::config

  exec { 'notify-fm-mgr':
    command => '/usr/bin/pkill -HUP fmManager',
    onlyif  => 'pgrep fmManager'
  }
}

class platform::fm::bootstrap {
  # Set up needed config to enable launching of fmManager later
  include ::platform::params
  include ::platform::fm::params
  include ::platform::fm::config
  include ::fm::client
  include ::fm::keystone::authtoken
  include ::fm::db::postgresql
  include ::fm::keystone::auth

  class { '::fm::api':
    host    => $::platform::fm::params::api_host,
    workers => $::platform::params::eng_workers,
    sync_db => true,
  }
}
