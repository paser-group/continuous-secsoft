class platform::dcdbsync::params (
  $api_port = 8219,
  $api_openstack_port = 8229,
  $region_name = undef,
  $service_create = false,
  $service_enabled = false,
  $default_endpoint_type = 'internalURL',
) {
  include ::platform::params
}

class platform::dcdbsync
  inherits ::platform::dcdbsync::params {
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    if $service_create {
      if $::platform::params::init_keystone {
        include ::dcdbsync::keystone::auth
      }

      class { '::dcdbsync': }
    }
  }
}

class platform::dcdbsync::api
  inherits ::platform::dcdbsync::params {
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    if $service_create {
      include ::platform::network::mgmt::params

      $api_host = $::platform::network::mgmt::params::controller_address
      $api_fqdn = $::platform::params::controller_hostname
      $url_host = "http://${api_fqdn}:${api_port}"

      class { '::dcdbsync::api':
        bind_host => $api_host,
        bind_port => $api_port,
        enabled   => $service_enabled,
      }
    }
  }

  include ::platform::dcdbsync::haproxy
}

class platform::dcdbsync::haproxy
  inherits ::platform::dcdbsync::params {
  include ::platform::params
  include ::platform::haproxy::params

  # Configure rules for https enabled admin endpoint.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    platform::haproxy::proxy { 'dcdbsync-restapi-admin':
      https_ep_type     => 'admin',
      server_name       => 's-dcdbsync',
      public_ip_address => $::platform::haproxy::params::private_ip_address,
      public_port       => $api_port + 1,
      private_port      => $api_port,
    }
  }
}

class platform::dcdbsync::stx_openstack::runtime
  inherits ::platform::dcdbsync::params {
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    if $service_create and
      $::platform::params::stx_openstack_applied {

      include ::platform::network::mgmt::params

      $api_host = $::platform::network::mgmt::params::controller_address
      $api_fqdn = $::platform::params::controller_hostname
      $url_host = "http://${api_fqdn}:${api_openstack_port}"

      class { '::dcdbsync::openstack_init': }
      class { '::dcdbsync::openstack_api':
        keystone_tenant         => 'service',
        keystone_user_domain    => 'service',
        keystone_project_domain => 'service',
        bind_host               => $api_host,
        bind_port               => $api_openstack_port,
        enabled                 => $service_enabled,
      }
    } else {
      class { '::dcdbsync::openstack_cleanup': }
    }
  }
}
