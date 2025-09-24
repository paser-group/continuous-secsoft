class platform::haproxy::params (
  $private_ip_address,
  $public_ip_address,
  $public_address_url,
  $enable_https = false,
  $https_ep_type = 'public',

  $global_options = undef,
  $tpm_object = undef,
  $tpm_engine = '/usr/lib64/openssl/engines/libtpm2.so',
) { }


define platform::haproxy::proxy (
  $server_name,
  $private_port,
  $public_port,
  $public_ip_address = undef,
  $private_ip_address = undef,
  $server_timeout = undef,
  $client_timeout = undef,
  $x_forwarded_proto = true,
  $enable_https = undef,
  $https_ep_type = undef,
  $public_api = true,
  $tcp_mode = false,
) {
  include ::platform::haproxy::params

  if $enable_https != undef {
    $https_enabled = $enable_https
  } else {
    $https_enabled = $::platform::haproxy::params::enable_https
  }

  if $https_ep_type != undef {
    $https_ep = $https_ep_type
  } else {
    $https_ep = $::platform::haproxy::params::https_ep_type
  }

  if $x_forwarded_proto {
    if $https_enabled and $public_api and $https_ep == 'public' {
        $ssl_option = 'ssl crt /etc/ssl/private/server-cert.pem'
        $proto = 'X-Forwarded-Proto:\ https'
        # The value of max-age matches lighttpd.conf, and should be
        # maintained for consistency
        $hsts_option = 'Strict-Transport-Security:\ max-age=63072000;\ includeSubDomains'
    } elsif $https_ep == 'admin' {
        $ssl_option = 'ssl crt /etc/ssl/private/admin-ep-cert.pem'
        $proto = 'X-Forwarded-Proto:\ https'
        $hsts_option = 'Strict-Transport-Security:\ max-age=63072000;\ includeSubDomains'
    } else {
      $ssl_option = ' '
      $proto = 'X-Forwarded-Proto:\ http'
      $hsts_option = undef
    }
  } else {
      $ssl_option = ' '
      $proto = undef
      $hsts_option = undef
  }

  if $tcp_mode {
    $mode_option = 'tcp'
  } else {
    $mode_option = undef
  }

  if $public_ip_address {
    $public_ip = $public_ip_address
  } else {
    $public_ip = $::platform::haproxy::params::public_ip_address
  }

  if $private_ip_address {
    $private_ip = $private_ip_address
  } else {
    $private_ip = $::platform::haproxy::params::private_ip_address
  }

  if $client_timeout {
    $real_client_timeout = "client ${client_timeout}"
  } else {
    $real_client_timeout = undef
  }

  haproxy::frontend { $name:
    collect_exported => false,
    name             => $name,
    bind             => {
      "${public_ip}:${public_port}" => $ssl_option,
    },
    options          => {
      'default_backend' => "${name}-internal",
      'reqadd'          => $proto,
      'timeout'         => $real_client_timeout,
      'rspadd'          => $hsts_option,
      'mode'            => $mode_option,
    },
  }

  if $server_timeout {
    $timeout_option = "server ${server_timeout}"
  } else {
    $timeout_option = undef
  }

  haproxy::backend { $name:
    collect_exported => false,
    name             => "${name}-internal",
    options          => {
      'server'  => "${server_name} ${private_ip}:${private_port}",
      'timeout' => $timeout_option,
      'mode'    => $mode_option,
    }
  }
}


class platform::haproxy::server {

  include ::platform::params
  include ::platform::haproxy::params

  # If TPM mode is enabled then we need to configure
  # the TPM object and the TPM OpenSSL engine in HAPROXY
  $tpm_object = $::platform::haproxy::params::tpm_object
  $tpm_engine = $::platform::haproxy::params::tpm_engine
  if $tpm_object != undef {
    $tpm_options = {'tpm-object' => $tpm_object, 'tpm-engine' => $tpm_engine}
    $global_options = merge($::platform::haproxy::params::global_options, $tpm_options)
  } else {
    $global_options = $::platform::haproxy::params::global_options
  }

  class { '::haproxy':
      global_options => $global_options,
  }

  user { 'haproxy':
    ensure => 'present',
    shell  => '/sbin/nologin',
    groups => [$::platform::params::protected_group_name],
  } -> Class['::haproxy']
}


class platform::haproxy::reload {
  platform::sm::restart {'haproxy': }
}


class platform::haproxy::runtime {
  include ::platform::haproxy::server

  include ::platform::patching::haproxy
  include ::platform::sysinv::haproxy
  include ::platform::nfv::haproxy
  include ::platform::ceph::haproxy
  include ::platform::fm::haproxy
  if ($::platform::params::distributed_cloud_role == 'systemcontroller' or
      $::platform::params::distributed_cloud_role == 'subcloud') {
    include ::platform::dcdbsync::haproxy
  }
  if $::platform::params::distributed_cloud_role =='systemcontroller' {
    include ::platform::dcmanager::haproxy
    include ::platform::dcorch::haproxy
  }
  include ::platform::docker::haproxy
  include ::openstack::keystone::haproxy
  include ::openstack::barbican::haproxy
  include ::platform::smapi::haproxy

  class {'::platform::haproxy::reload':
    stage => post
  }
}

class platform::haproxy::restart::runtime {
  class {'::platform::haproxy::reload':
    stage => post
  }
}

