class platform::patching::params (
  $private_port = 5491,
  $public_port = 15491,
  $server_timeout = '600s',
  $region_name = undef,
  $service_create = false,
) { }


class platform::patching
  inherits ::platform::patching::params {

  include ::platform::params
  include ::openstack::horizon::params

  $http_port        = $::openstack::horizon::params::http_port
  $software_version = $::platform::params::software_version
  $base_url         = "http://controller:${http_port}/feed/rel-${software_version}"
  $updates_url      = "http://controller:${http_port}/updates/rel-${software_version}"

  file { '/etc/yum.repos.d/platform.repo':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('platform/platform.yum.repo.erb'),
  }

  group { 'patching':
    ensure => 'present',
  }
  -> user { 'patching':
    ensure           => 'present',
    comment          => 'patching Daemons',
    groups           => ['nobody', 'patching', $::platform::params::protected_group_name],
    home             => '/var/lib/patching',
    password         => '!!',
    password_max_age => '-1',
    password_min_age => '-1',
    shell            => '/sbin/nologin',
  }
  -> file { '/etc/patching':
    ensure => 'directory',
    owner  => 'patching',
    group  => 'patching',
    mode   => '0755',
  }
  -> class { '::patching': }
}


class platform::patching::haproxy
  inherits ::platform::patching::params {
  include ::platform::params
  include ::platform::haproxy::params

  platform::haproxy::proxy { 'patching-restapi':
    server_name    => 's-patching',
    public_port    => $public_port,
    private_port   => $private_port,
    server_timeout => $server_timeout,
  }

  # Configure rules for DC https enabled admin endpoint.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    platform::haproxy::proxy { 'patching-restapi-admin':
      https_ep_type     => 'admin',
      server_name       => 's-patching',
      public_ip_address => $::platform::haproxy::params::private_ip_address,
      public_port       => $private_port + 1,
      private_port      => $private_port,
      server_timeout    => $server_timeout,
    }
  }
}


class platform::patching::api (
) inherits ::platform::patching::params {

  include ::patching::api

  if ($::platform::patching::params::service_create and
      $::platform::params::init_keystone) {
    include ::patching::keystone::auth
  }

  include ::platform::patching::haproxy
}

class platform::patching::agent::reload {

  exec { 'restart sw-patch-agent':
    command   => '/usr/sbin/sw-patch-agent-restart',
    logoutput => true,
  }
}

class platform::patching::runtime {

  class {'::platform::patching::agent::reload':
    stage => post
  }
}
