class platform::smapi::params (
  $auth_username = undef,
  $keystone_auth_url = undef,
  $keystone_username = undef,
  $keystone_password = undef,
  $public_url = undef,
  $admin_url = undef,
  $bind_ip = undef,
  $port = undef,
  $region = undef,
) {}

class platform::smapi::haproxy
  inherits ::platform::smapi::params {

  include ::platform::params
  include ::platform::haproxy::params

  platform::haproxy::proxy { 'sm-api-internal':
    server_name        => 's-smapi-internal',
    public_ip_address  => $::platform::haproxy::params::private_ip_address,
    public_port        => $port,
    public_api         => false,
    private_ip_address => $bind_ip,
    private_port       => $port,
  }
  platform::haproxy::proxy { 'sm-api-public':
    server_name  => 's-smapi-public',
    public_port  => $port,
    private_port => $port,
  }

  # Configure rules for DC https enabled admin endpoint.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    platform::haproxy::proxy { 'sm-api-admin':
      https_ep_type     => 'admin',
      server_name       => 's-smapi-admin',
      public_ip_address => $::platform::haproxy::params::private_ip_address,
      public_port       => $port + 1,
      private_port      => $port,
    }
  }
}

class platform::smapi
  inherits ::platform::smapi::params {
  if ($::platform::params::init_keystone) {
      include ::smapi::keystone::auth
  }

  include ::platform::params
  include ::platform::smapi::haproxy
  $bind_host_name = $::platform::params::hostname
  file { '/etc/sm-api/sm-api.conf':
    ensure  => 'present',
    content => template('platform/sm-api.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }
}

