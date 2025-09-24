class platform::config::params (
  $config_uuid = 'install',
  $hosts = {},
  $timezone = 'UTC',
) { }


class platform::config::certs::params (
  $ssl_ca_cert = '',
) { }


class platform::config
  inherits ::platform::config::params {

  include ::platform::params
  include ::platform::anchors

  stage { 'pre':
    before => Stage['main'],
  }

  stage { 'post':
    require => Stage['main'],
  }

  class { '::platform::config::pre':
    stage => pre
  }

  class { '::platform::config::post':
    stage => post,
  }
}


class platform::config::file {

  include ::platform::params
  include ::platform::network::mgmt::params
  include ::platform::network::oam::params
  include ::platform::network::cluster_host::params
  include ::openstack::horizon::params

  # dependent template variables
  $management_interface = $::platform::network::mgmt::params::interface_name
  $cluster_host_interface = $::platform::network::cluster_host::params::interface_name
  $oam_interface = $::platform::network::oam::params::interface_name

  $platform_conf = '/etc/platform/platform.conf'

  file_line { "${platform_conf} sw_version":
    path  => $platform_conf,
    line  => "sw_version=${::platform::params::software_version}",
    match => '^sw_version=',
  }

  if $management_interface {
    file_line { "${platform_conf} management_interface":
      path  => $platform_conf,
      line  => "management_interface=${management_interface}",
      match => '^management_interface=',
    }
  }

  if $cluster_host_interface {
    file_line { "${platform_conf} cluster_host_interface":
      path  => '/etc/platform/platform.conf',
      line  => "cluster_host_interface=${cluster_host_interface}",
      match => '^cluster_host_interface=',
    }
  }
  else {
    file_line { "${platform_conf} cluster_host_interface":
      ensure            => absent,
      path              => '/etc/platform/platform.conf',
      match             => '^cluster_host_interface=',
      match_for_absence => true,
    }
  }

  if $oam_interface {
    file_line { "${platform_conf} oam_interface":
      path  => $platform_conf,
      line  => "oam_interface=${oam_interface}",
      match => '^oam_interface=',
    }
  }

  if $::platform::params::vswitch_type {
    file_line { "${platform_conf} vswitch_type":
      path  => $platform_conf,
      line  => "vswitch_type=${::platform::params::vswitch_type}",
      match => '^vswitch_type=',
    }
  }

  if $::platform::params::system_type {
    file_line { "${platform_conf} system_type":
      path  => $platform_conf,
      line  => "system_type=${::platform::params::system_type}",
      match => '^system_type=*',
    }
  }

  if $::platform::params::system_mode {
    file_line { "${platform_conf} system_mode":
      path  => $platform_conf,
      line  => "system_mode=${::platform::params::system_mode}",
      match => '^system_mode=*',
    }
  }

  if $::platform::params::security_profile {
    file_line { "${platform_conf} security_profile":
      path  => $platform_conf,
      line  => "security_profile=${::platform::params::security_profile}",
      match => '^security_profile=*',
    }
  }

  if $::platform::params::sdn_enabled {
    file_line { "${platform_conf}f sdn_enabled":
      path  => $platform_conf,
      line  => 'sdn_enabled=yes',
      match => '^sdn_enabled=',
    }
  }
  else {
    file_line { "${platform_conf} sdn_enabled":
      path  => $platform_conf,
      line  => 'sdn_enabled=no',
      match => '^sdn_enabled=',
    }
  }

  if $::platform::params::region_config {
    file_line { "${platform_conf} region_config":
      path  => $platform_conf,
      line  => 'region_config=yes',
      match => '^region_config=',
    }
    file_line { "${platform_conf} region_1_name":
      path  => $platform_conf,
      line  => "region_1_name=${::platform::params::region_1_name}",
      match => '^region_1_name=',
    }
    file_line { "${platform_conf} region_2_name":
      path  => $platform_conf,
      line  => "region_2_name=${::platform::params::region_2_name}",
      match => '^region_2_name=',
    }
  } else {
    file_line { "${platform_conf} region_config":
      path  => $platform_conf,
      line  => 'region_config=no',
      match => '^region_config=',
    }
  }

  if $::platform::params::distributed_cloud_role {
    file_line { "${platform_conf} distributed_cloud_role":
      path  => $platform_conf,
      line  => "distributed_cloud_role=${::platform::params::distributed_cloud_role}",
      match => '^distributed_cloud_role=',
    }
  }

  if $::platform::params::security_feature {
    file_line { "${platform_conf} security_feature":
      path  => $platform_conf,
      line  => "security_feature=\"${::platform::params::security_feature}\"",
      match => '^security_feature=*',
    }
  }

  file_line { "${platform_conf} http_port":
    path  => $platform_conf,
    line  => "http_port=${::openstack::horizon::params::http_port}",
    match => '^http_port=',
  }

}


class platform::config::hostname {
  include ::platform::params

  file { '/etc/hostname':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "${::platform::params::hostname}\n",
    notify  => Exec['set-hostname'],
  }

  exec { 'set-hostname':
    command => 'hostname -F /etc/hostname',
    unless  => 'test `hostname` = `cat /etc/hostname`',
  }
}


class platform::config::hosts
  inherits ::platform::config::params {

  # The localhost should resolve to the IPv4 loopback address only, therefore
  # ensure the IPv6 address is removed from configured hosts
  resources { 'host': purge => true }

  $localhost = {
    'localhost' => {
      ip => '127.0.0.1',
      host_aliases => ['localhost.localdomain', 'localhost4', 'localhost4.localdomain4']
    },
  }

  $merged_hosts = merge($localhost, $hosts)
  create_resources('host', $merged_hosts, {})
}


class platform::config::timezone
  inherits ::platform::config::params {
  exec { 'Configure Timezone':
    command => "ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime",
  }
}


class platform::config::tpm {
  $tpm_certs = hiera_hash('platform::tpm::tpm_data', undef)
  if $tpm_certs != undef {
    # iterate through each tpm_cert creating it if it doesn't exist
    $tpm_certs.each |String $key, String $value| {
      file { "create-TPM-cert-${key}":
        ensure  => present,
        path    => $key,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => $value,
      }
    }
  }
}


class platform::config::certs::ssl_ca
  inherits ::platform::config::certs::params {

  $ssl_ca_file = '/etc/pki/ca-trust/source/anchors/ca-cert.pem'
  if str2bool($::is_initial_config) {
    $containerd_restart_cmd = 'systemctl restart containerd'
  }
  else {
    $containerd_restart_cmd = 'pmon-restart containerd'
  }

  if ! empty($ssl_ca_cert) {
    file { 'create-ssl-ca-cert':
      ensure  => present,
      path    => $ssl_ca_file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $ssl_ca_cert,
    }
  }
  else {
    file { 'create-ssl-ca-cert':
      ensure => absent,
      path   => $ssl_ca_file
    }
  }
  exec { 'update-ca-trust ':
    command     => 'update-ca-trust',
    subscribe   => File[$ssl_ca_file],
    refreshonly => true
  }
  # Restart containerd also cause docker to restart.
  -> exec { 'restart containerd':
    command     => $containerd_restart_cmd,
    subscribe   => File[$ssl_ca_file],
    refreshonly => true
  }
  if str2bool($::is_controller_active) {
    Exec['restart containerd']
    -> file { '/etc/platform/.ssl_ca_complete':
      ensure => present,
      owner  => root,
      group  => root,
      mode   => '0644',
    }
  }
}

class platform::config::dccert::params (
  $dc_root_ca_crt = '',
  $dc_adminep_crt = ''
) { }


class platform::config::dc_root_ca
  inherits ::platform::config::dccert::params {
  $dc_root_ca_file = '/etc/pki/ca-trust/source/anchors/dc-adminep-root-ca.crt'
  $dc_adminep_cert_file = '/etc/ssl/private/admin-ep-cert.pem'

  if ! empty($dc_adminep_crt) {
    file { 'adminep-cert':
      ensure  => present,
      path    => $dc_adminep_cert_file,
      owner   => root,
      group   => root,
      mode    => '0400',
      content => $dc_adminep_crt,
    }
  }

  if ! empty($dc_root_ca_crt) {
    file { 'create-dc-adminep-root-ca-cert':
      ensure  => present,
      path    => $dc_root_ca_file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => $dc_root_ca_crt,
    }
    -> exec { 'update-dc-ca-trust':
      command     => 'update-ca-trust',
    }
  }
}


class platform::config::runtime {
  include ::platform::config::certs::ssl_ca
}

class platform::config::dc_root_ca::runtime {
  include platform::config::dc_root_ca
}

class platform::config::pre {
  group { 'nobody':
    ensure => 'present',
    gid    => '99',
  }

  include ::platform::config::timezone
  include ::platform::config::hostname
  include ::platform::config::hosts
  include ::platform::config::file
  include ::platform::config::tpm
  include ::platform::config::certs::ssl_ca
  if ($::platform::params::distributed_cloud_role =='systemcontroller' and
      $::personality == 'controller') {
    include ::platform::config::dc_root_ca
  }
}


class platform::config::post
  inherits ::platform::config::params {

  include ::platform::params

  service { 'crond':
    ensure => 'running',
    enable => true,
  }

  # When applying manifests to upgrade controller-1, we do not want SM or the
  # sysinv-agent or anything else that depends on these flags to start.
  if ! $::platform::params::controller_upgrade {
    file { '/etc/platform/.config_applied':
      ensure  => present,
      mode    => '0640',
      content => "CONFIG_UUID=${config_uuid}"
    }
  }
}

class platform::config::controller::post
{
  include ::platform::params

  if ! $::platform::params::controller_upgrade {
    file { '/etc/platform/.initial_config_complete':
      ensure => present,
    }
  }

  file { '/etc/platform/.initial_controller_config_complete':
    ensure => present,
  }

  file { '/var/run/.controller_config_complete':
    ensure => present,
  }
}

class platform::config::worker::post
{
  include ::platform::params

  if ! $::platform::params::controller_upgrade {
    file { '/etc/platform/.initial_config_complete':
      ensure => present,
    }
  }

  file { '/etc/platform/.initial_worker_config_complete':
    ensure => present,
  }

  file { '/var/run/.worker_config_complete':
    ensure => present,
  }

  include ::platform::compute::grub::audit
}

class platform::config::storage::post
{
  include ::platform::params

  if ! $::platform::params::controller_upgrade {
    file { '/etc/platform/.initial_config_complete':
      ensure => present,
    }
  }

  file { '/etc/platform/.initial_storage_config_complete':
    ensure => present,
  }

  file { '/var/run/.storage_config_complete':
    ensure => present,
  }
}

class platform::config::bootstrap {
  stage { 'pre':
    before => Stage['main'],
  }

  stage { 'post':
    require => Stage['main'],
  }

  include ::platform::params
  include ::platform::anchors
  include ::platform::config::hostname
  include ::platform::config::hosts
}
