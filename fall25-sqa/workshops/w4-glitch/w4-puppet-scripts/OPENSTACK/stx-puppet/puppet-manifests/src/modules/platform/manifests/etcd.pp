class platform::etcd::params (
  $bind_address = '0.0.0.0',
  $bind_address_version = 4,
  $port    = 2379,
  $node   = 'controller',
  $security_enabled = undef,
)
{
  include ::platform::params

  $sw_version = $::platform::params::software_version
  $etcd_basedir = '/opt/etcd'
  $etcd_versioned_dir = "${etcd_basedir}/${sw_version}"
}

# Modify the systemd service file for etcd and
# create an init.d script for SM to manage the service
class platform::etcd::setup {

  file {'etcd_override_dir':
    ensure => directory,
    path   => '/etc/systemd/system/etcd.service.d',
    mode   => '0755',
  }
  -> file {'etcd_override':
    ensure => present,
    path   => '/etc/systemd/system/etcd.service.d/etcd-override.conf',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/etcd-override.conf"
  }
  -> file {'etcd_initd_script':
    ensure => 'present',
    path   => '/etc/init.d/etcd',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/etcd"
  }
  -> exec { 'systemd-reload-daemon':
    command     => '/usr/bin/systemctl daemon-reload',
  }
  -> Service['etcd']
}

class platform::etcd::init (
  $service_enabled = false,
) inherits ::platform::etcd::params {

  if $service_enabled {
    $service_ensure = 'running'
  }
  else {
    $service_ensure = 'stopped'
  }

  if $security_enabled {
    $client_cert_auth = true
    $cert_file = '/etc/etcd/etcd-server.crt'
    $key_file = '/etc/etcd/etcd-server.key'
    $trusted_ca_file = '/etc/etcd/ca.crt'
    if $bind_address_version == $::platform::params::ipv6 {
      $client_url = "https://[${bind_address}]:${port}"
    }
    else {
      $client_url = "https://${bind_address}:${port}"
    }
  }
  else {
    # This else part can be removed after STX5.0
    $client_cert_auth = false
    $cert_file = undef
    $key_file = undef
    $trusted_ca_file = undef
    if $bind_address_version == $::platform::params::ipv6 {
      $client_url = "http://[${bind_address}]:${port}"
    }
    else {
      $client_url = "http://${bind_address}:${port}"
    }
  }

  class { 'etcd':
    ensure                => 'present',
    etcd_name             => $node,
    service_enable        => false,
    service_ensure        => $service_ensure,
    cluster_enabled       => false,
    listen_client_urls    => $client_url,
    advertise_client_urls => $client_url,
    data_dir              => "${etcd_versioned_dir}/${node}.etcd",
    proxy                 => 'off',
    client_cert_auth      => $client_cert_auth,
    cert_file             => $cert_file,
    key_file              => $key_file,
    trusted_ca_file       => $trusted_ca_file,
  }
}


class platform::etcd
  inherits ::platform::etcd::params {

  Class['::platform::drbd::etcd'] -> Class[$name]

  include ::platform::etcd::datadir
  include ::platform::etcd::setup
  include ::platform::etcd::init

  Class['::platform::etcd::datadir']
  -> Class['::platform::etcd::setup']
  -> Class['::platform::etcd::init']
}

class platform::etcd::datadir
  inherits ::platform::etcd::params {

  Class['::platform::drbd::etcd'] -> Class[$name]

  if $::platform::params::init_database {
    file { $etcd_versioned_dir:
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }
  }
}

class platform::etcd::upgrade::runtime
  inherits ::platform::etcd::params {

  include ::platform::etcd::init

  $server_url = $::platform::etcd::init::client_url
  $etcd_cert = '/etc/etcd/etcd-client.crt'
  $etcd_key = '/etc/etcd/etcd-client.key'
  $etcd_ca = '/etc/etcd/ca.crt'

  if ! str2bool($::is_controller_active) {
    file { '/etc/etcd/etcd-server.crt':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/etcd-server.crt",
    }

    -> file { '/etc/etcd/etcd-server.key':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/etcd-server.key",
    }

    -> file { '/etc/etcd/etcd-client.crt':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/etcd-client.crt",
    }

    -> file { '/etc/etcd/etcd-client.key':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/etcd-client.key",
    }

    -> file { '/etc/etcd/ca.crt':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/ca.crt",
    }

    -> file { '/etc/kubernetes/pki/apiserver-etcd-client.crt':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/apiserver-etcd-client.crt",
    }

    -> file { '/etc/kubernetes/pki/apiserver-etcd-client.key':
      ensure  => 'present',
      replace => true,
      source  => "/var/run/platform/config/${sw_version}/etcd/apiserver-etcd-client.key",
    }

    -> class { '::platform::kubernetes::master::change_apiserver_parameters':
      etcd_cafile   => '/etc/kubernetes/pki/ca.crt',
      etcd_certfile => '/etc/kubernetes/pki/apiserver-etcd-client.crt',
      etcd_keyfile  => '/etc/kubernetes/pki/apiserver-etcd-client.key',
      etcd_servers  => $server_url,
    }
  }
  else {
    class { '::platform::kubernetes::master::change_apiserver_parameters':
      etcd_cafile   => '/etc/kubernetes/pki/ca.crt',
      etcd_certfile => '/etc/kubernetes/pki/apiserver-etcd-client.crt',
      etcd_keyfile  => '/etc/kubernetes/pki/apiserver-etcd-client.key',
      etcd_servers  => $server_url,
    }

    -> exec { 'restart-etcd':
      command => '/usr/bin/systemctl restart etcd.service',
    }

    -> exec { 'create-etcd-root-account':
      command => "etcdctl --cert-file=${etcd_cert} --key-file=${etcd_key} --ca-file=${etcd_ca} --endpoint=${server_url} \
                  user add root:sysadmin",
    }

    -> exec { 'create-etcd-user-account':
      command => "etcdctl --cert-file=${etcd_cert} --key-file=${etcd_key} --ca-file=${etcd_ca} --endpoint=${server_url} \
                  user add apiserver-etcd-client:sysadmin",
    }

    -> exec { 'enable-etcd-auth':
      command => "etcdctl --cert-file=${etcd_cert} --key-file=${etcd_key} --ca-file=${etcd_ca} --endpoint=${server_url} \
                  auth enable",
      returns => [0,1]
    }
  }
}

class platform::etcd::datadir::bootstrap
  inherits ::platform::etcd::params {

  require ::platform::drbd::etcd::bootstrap
  Class['::platform::drbd::etcd::bootstrap'] -> Class[$name]

  file { $etcd_versioned_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
  }
}

class platform::etcd::bootstrap
  inherits ::platform::etcd::params {

  include ::platform::etcd::datadir::bootstrap
  include ::platform::etcd::setup

  Class['::platform::etcd::datadir::bootstrap']
  -> Class['::platform::etcd::setup']
  -> class { '::platform::etcd::init':
    service_enabled => false,
  }
}
