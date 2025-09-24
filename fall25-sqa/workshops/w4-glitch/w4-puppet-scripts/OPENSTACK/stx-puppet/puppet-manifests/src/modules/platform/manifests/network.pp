class platform::network::pxeboot::params(
  # shared parameters with base class - required for auto hiera parameter lookup
  $interface_name = undef,
  $interface_address = undef,
  $interface_devices = [],
  $subnet_version = undef,
  $subnet_network = undef,
  $subnet_network_url = undef,
  $subnet_prefixlen = undef,
  $subnet_netmask = undef,
  $subnet_start = undef,
  $subnet_end = undef,
  $gateway_address = undef,
  $controller_address = undef,  # controller floating
  $controller_address_url = undef,  # controller floating url address
  $controller0_address = undef, # controller unit0
  $controller1_address = undef, # controller unit1
  $mtu = 1500,
) { }


class platform::network::mgmt::params(
  # shared parameters with base class - required for auto hiera parameter lookup
  $interface_name = undef,
  $interface_address = undef,
  $interface_devices = [],
  $subnet_version = undef,
  $subnet_network = undef,
  $subnet_network_url = undef,
  $subnet_prefixlen = undef,
  $subnet_netmask = undef,
  $subnet_start = undef,
  $subnet_end = undef,
  $gateway_address = undef,
  $controller_address = undef,  # controller floating
  $controller_address_url = undef,  # controller floating url address
  $controller0_address = undef, # controller unit0
  $controller1_address = undef, # controller unit1
  $mtu = 1500,
  # network type specific parameters
  $platform_nfs_address = undef,
) { }

class platform::network::oam::params(
  # shared parameters with base class - required for auto hiera parameter lookup
  $interface_name = undef,
  $interface_address = undef,
  $interface_devices = [],
  $subnet_version = undef,
  $subnet_network = undef,
  $subnet_network_url = undef,
  $subnet_prefixlen = undef,
  $subnet_netmask = undef,
  $subnet_start = undef,
  $subnet_end = undef,
  $gateway_address = undef,
  $controller_address = undef,  # controller floating
  $controller_address_url = undef,  # controller floating url address
  $controller0_address = undef, # controller unit0
  $controller1_address = undef, # controller unit1
  $mtu = 1500,
) { }

class platform::network::cluster_host::params(
  # shared parameters with base class - required for auto hiera parameter lookup
  $interface_name = undef,
  $interface_address = undef,
  $interface_devices = [],
  $subnet_version = undef,
  $subnet_network = undef,
  $subnet_network_url = undef,
  $subnet_prefixlen = undef,
  $subnet_netmask = undef,
  $subnet_start = undef,
  $subnet_end = undef,
  $gateway_address = undef,
  $controller_address = undef,  # controller floating
  $controller_address_url = undef,  # controller floating url address
  $controller0_address = undef, # controller unit0
  $controller1_address = undef, # controller unit1
  $mtu = 1500,
) { }

class platform::network::ironic::params(
  # shared parameters with base class - required for auto hiera parameter lookup
  $interface_name = undef,
  $interface_address = undef,
  $interface_devices = [],
  $subnet_version = undef,
  $subnet_network = undef,
  $subnet_network_url = undef,
  $subnet_prefixlen = undef,
  $subnet_netmask = undef,
  $subnet_start = undef,
  $subnet_end = undef,
  $gateway_address = undef,
  $controller_address = undef,  # controller floating
  $controller_address_url = undef,  # controller floating url address
  $controller0_address = undef, # controller unit0
  $controller1_address = undef, # controller unit1
  $mtu = 1500,
) { }

define network_address (
  $address,
  $ifname,
) {
  # In AIO simplex configurations, the management addresses are assigned to the
  # loopback interface. These addresses must be assigned using the host scope
  # or assignment is prevented (can't have multiple global scope addresses on
  # the loopback interface).

  # For ipv6 the only way to initiate outgoing connections
  # over the fixed ips is to set preferred_lft to 0 for the
  # floating ips so that they are not used
  if $ifname == 'lo' {
    $options = 'scope host'
  } elsif $::platform::network::mgmt::params::subnet_version == $::platform::params::ipv6 {
    $options = 'preferred_lft 0'
  } else {
    $options = ''
  }

  # addresses should only be configured if running in simplex, otherwise SM
  # will configure them on the active controller.
  exec { "Configuring ${name} IP address":
    command => "ip addr replace ${address} dev ${ifname} ${options}",
    onlyif  => 'test -f /etc/platform/simplex',
  }
}


class platform::network::addresses (
  $address_config = {},
) {
  create_resources('network_address', $address_config, {})
}


# Defines a single route resource for an interface.
# If multiple are required in the future, then this will need to
# iterate over a hash to create multiple entries per file.
define network_route6 (
  $prefix,
  $gateway,
  $ifname,
) {
  file { "/etc/sysconfig/network-scripts/route6-${ifname}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "${prefix} via ${gateway} dev ${ifname}"
  }
}


class platform::network::routes (
  $route_config = {}
) {
  create_resources('network_route', $route_config, {})

  include ::platform::params
  include ::platform::network::mgmt::params

  # Add static IPv6 default route since DHCPv6 does not support the router option
  if $::personality != 'controller' {
    if $::platform::network::mgmt::params::subnet_version == $::platform::params::ipv6 {
      network_route6 { 'ipv6 default route':
        prefix  => 'default',
        gateway => $::platform::network::mgmt::params::controller_address,
        ifname  => $::platform::network::mgmt::params::interface_name
      }
    }
  }
}


define platform::interfaces::sriov_enable (
  $addr,
  $device_id,
  $num_vfs,
  $port_name,
  $vf_config = undef
) {
  $vf_file = 'sriov_numvfs'
  if ($num_vfs != undef) and ($num_vfs > 0) {
    exec { "sriov-enable-device: ${title}":
      command   => template('platform/sriov.enable-device.erb'),
      logoutput => true,
    }
  }
}


define platform::interfaces::sriov_bind (
  $addr,
  $driver,
  $vfnumber = undef,
  $max_tx_rate = undef
) {
  if ($driver != undef) {
    ensure_resource(kmod::load, $driver)
    Anchor['platform::networking']
    -> exec { "sriov-vf-bind-device: ${title}":
      command   => template('platform/sriov.bind-device.erb'),
      logoutput => true,
      require   => [ Kmod::Load[$driver] ],
    }
  }
}

define platform::interfaces::sriov_vf_bind (
  $addr,
  $device_id,
  $num_vfs,
  $port_name,
  $vf_config
) {
  if ($device_id == '0d58') {
    include ::platform::devices::fpga::n3000::reset
    exec { "Restarting n3000 NICs for interface: ${title}":
      command => "ifdown ${port_name}; ifup ${port_name}",
      path    => '/usr/sbin/',
      require => Class['::platform::devices::fpga::n3000::reset']
    }
    -> Platform::Interfaces::Sriov_bind <| |>
  }
  create_resources('platform::interfaces::sriov_bind', $vf_config, {})
}


define platform::interfaces::sriov_ratelimit (
  $addr,
  $driver,
  $port_name,
  $vfnumber = undef,
  $max_tx_rate = undef
) {
  if $max_tx_rate {
    exec { "sriov-vf-rate-limit: ${title}":
      command   => template('platform/sriov.ratelimit.erb'),
      logoutput => true,
      tries     => 5,
      try_sleep => 1,
    }
  }
}

define platform::interfaces::sriov_vf_ratelimit (
  $addr,
  $device_id,
  $num_vfs,
  $port_name,
  $vf_config
) {
  create_resources('platform::interfaces::sriov_ratelimit', $vf_config, {port_name => $port_name})
}

class platform::interfaces::sriov (
  $sriov_config = {},
  $runtime = false
) {
  if $runtime {
    create_resources('platform::interfaces::sriov_enable', $sriov_config, {})
  } else {
    create_resources('platform::interfaces::sriov_vf_bind', $sriov_config, {})
    create_resources('platform::interfaces::sriov_vf_ratelimit', $sriov_config, {})
    Platform::Interfaces::Sriov_vf_bind <| |> -> Class['::platform::kubernetes::worker::sriovdp']
  }
}


class platform::interfaces::sriov::runtime {
  class { 'platform::interfaces::sriov': runtime => true }
}


class platform::interfaces (
  $network_config = {},
) {
  create_resources('network_config', $network_config, {})
}


class platform::network::apply {
  include ::platform::interfaces
  include ::platform::network::addresses
  include ::platform::network::routes

  Network_config <| |>
  -> Exec['apply-network-config']
  -> Network_address <| |>
  -> Exec['wait-for-tentative']
  -> Anchor['platform::networking']

  # Adding Network_route dependency separately, in case it's empty,
  # as puppet bug will remove dependency altogether if
  # Network_route is empty. See below.
  # https://projects.puppetlabs.com/issues/18399
  Network_config <| |>
  -> Network_route <| |>
  -> Exec['apply-network-config']

  Network_config <| |>
  -> Network_route6 <| |>
  -> Exec['apply-network-config']

  exec {'apply-network-config':
    command => 'apply_network_config.sh',
  }
  # Wait for network interface to leave tentative state during ipv6 DAD
  exec {'wait-for-tentative':
    command   => '[ $(ip -6 addr sh | grep -c inet6.*tentative) -eq 0 ]',
    tries     => 10,
    try_sleep => 1,
  }
}


class platform::network (
  $mlx4_core_options = undef,
) {
  include ::platform::params
  include ::platform::network::mgmt::params
  include ::platform::network::cluster_host::params

  include ::platform::network::apply

  $management_interface = $::platform::network::mgmt::params::interface_name

  $testcmd = '/usr/local/bin/connectivity_test'

  if $::personality != 'controller' {
    if $management_interface {
      exec { 'connectivity-test-management':
        command => "${testcmd} -t 70 -i ${management_interface} controller-platform-nfs; /bin/true",
        require => Anchor['platform::networking'],
        onlyif  => 'test ! -f /etc/platform/simplex',
      }
    }
  }

  if $mlx4_core_options {
    exec { 'mlx4-core-config':
      command     => '/usr/bin/mlx4_core_config.sh',
      subscribe   => File['/etc/modprobe.d/mlx4_sriov.conf'],
      refreshonly => true
    }

    file {'/etc/modprobe.d/mlx4_sriov.conf':
      content => "options mlx4_core ${mlx4_core_options}"
    }
  }
}


class platform::network::runtime {
  include ::platform::network::apply
}


class platform::network::routes::runtime {
  include ::platform::network::routes

  # Adding Network_route dependency separately, in case it's empty,
  # as puppet bug will remove dependency altogether if
  # Network_route is empty. See below.
  # https://projects.puppetlabs.com/issues/18399
  Network_route <| |> -> Exec['apply-network-config route setup']
  Network_route6 <| |> -> Exec['apply-network-config route setup']

  exec {'apply-network-config route setup':
    command => 'apply_network_config.sh --routes',
  }
}
