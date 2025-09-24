class platform::containerd::params (
  $package_name = 'containerd',
  $http_proxy   = undef,
  $https_proxy  = undef,
  $no_proxy     = undef,
  $k8s_registry    = undef,
  $insecure_registries = undef,
  $k8s_cni_bin_dir = '/usr/libexec/cni',
  $stream_server_address = 'localhost',
  $custom_container_runtime = undef,
) { }

class platform::containerd::config
  inherits ::platform::containerd::params {

  include ::platform::docker::params
  include ::platform::dockerdistribution::params
  include ::platform::kubernetes::params
  include ::platform::dockerdistribution::registries
  include ::platform::params
  include ::platform::mtce::params

  # If containerd is started prior to networking providing a default route, the
  # containerd cri plugin will fail to load and the status of the cri plugin
  # will be in 'error'. This will prevent any crictl image pulls from working as
  # containerd is not automatically restarted when plugins fail to load.
  Anchor['platform::networking'] -> Class[$name]

  # inherit the proxy setting from docker
  $http_proxy = $::platform::docker::params::http_proxy
  $https_proxy = $::platform::docker::params::https_proxy
  if $::platform::docker::params::no_proxy {
    # Containerd doesn't work with the NO_PROXY environment
    # variable if it has IPv6 addresses with square brackets,
    # remove the square brackets
    $no_proxy = regsubst($::platform::docker::params::no_proxy, '\\[|\\]', '', 'G')
  }
  $insecure_registries = $::platform::dockerdistribution::registries::insecure_registries
  $distributed_cloud_role = $::platform::params::distributed_cloud_role

  # grab custom cri class entries
  $custom_container_runtime = $::platform::containerd::params::custom_container_runtime

  if $http_proxy or $https_proxy {
    file { '/etc/systemd/system/containerd.service.d':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    -> file { '/etc/systemd/system/containerd.service.d/http-proxy.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      # share the same template as docker, since the conf file is the same
      content => template('platform/dockerproxy.conf.erb'),
    }
    ~> exec { 'perform systemctl daemon reload for containerd proxy':
      command     => 'systemctl daemon-reload',
      logoutput   => true,
      refreshonly => true,
    } ~> Service['containerd']
  }

  Class['::platform::filesystem::docker'] ~> Class[$name]

  # get cni bin directory
  $k8s_cni_bin_dir = $::platform::kubernetes::params::k8s_cni_bin_dir

  # generate the registry auth
  $registry_auth = chomp(
    base64('encode',
      join([$::platform::mtce::params::auth_username,
            $::platform::mtce::params::auth_pw], ':')))

  if $::platform::network::mgmt::params::subnet_version == $::platform::params::ipv6 {
    $stream_server_address = '::1'
  } else {
    $stream_server_address = '127.0.0.1'
  }

  file { '/etc/containerd':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  -> file { '/etc/containerd/config.toml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('platform/config.toml.erb'),
  }
  -> service { 'containerd':
    ensure  => 'running',
    name    => 'containerd',
    enable  => true,
    require => Package['containerd']
  }
  -> exec { 'enable-containerd':
    command => '/usr/bin/systemctl enable containerd.service',
  }
  -> exec { 'restart-containerd':
    # containerd may be already started by docker. Need restart it after configuration
    command => '/usr/bin/systemctl restart containerd.service',
  }
}

class platform::containerd::install
  inherits ::platform::containerd::params {

  package { 'containerd':
    ensure => 'installed',
    name   => $package_name,
  }
}

class platform::containerd::controller
{
  include ::platform::containerd::install
  include ::platform::containerd::config
}

class platform::containerd::worker
{
  if $::personality != 'controller' {
    include ::platform::containerd::install
    include ::platform::containerd::config
  }
}

class platform::containerd::storage
{
  if $::personality != 'controller' {
    include ::platform::containerd::install
    include ::platform::containerd::config
  }
}
