define qat_device_files(
  $qat_idx,
  $device_id,
) {
  if $device_id == 'dh895xcc'{
      file { "/etc/dh895xcc_dev${qat_idx}.conf":
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0640',
        notify => Service['qat_service'],
      }
  }

  if $device_id == 'c62x'{
      file { "/etc/c62x_dev${qat_idx}.conf":
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0640',
        notify => Service['qat_service'],
      }
  }
}

class platform::devices::qat (
  $device_config = {},
  $service_enabled = false
)
{
  if $service_enabled {
    create_resources('qat_device_files', $device_config)

    service { 'qat_service':
      ensure     => 'running',
      enable     => true,
      hasrestart => true,
      notify     => Service['sysinv-agent'],
    }
  }
}

define platform::devices::sriov_enable (
  $num_vfs,
  $addr,
  $driver,
  $device_id
) {
  if ($driver == 'igb_uio') {
    $vf_file = 'max_vfs'
  } else {
    $vf_file = 'sriov_numvfs'
  }
  if ($num_vfs > 0) {
    if ($device_id == '0d8f') {
      include platform::devices::fpga::n3000::reset
      Class['platform::devices::fpga::n3000::reset']
      -> Exec["sriov-enable-device: ${title}"]
    }
    exec { "sriov-enable-device: ${title}":
      command   => template('platform/sriov.enable-device.erb'),
      logoutput => true,
    }
  }
}

define platform::devices::sriov_bind (
  $addr,
  $driver,
  $num_vfs = undef,
  $device_id = undef
) {
  if ($driver != undef) and ($addr != undef) {
    if ($device_id != undef) and ($device_id == '0d8f') {
      include platform::devices::fpga::n3000::reset
      Class['platform::devices::fpga::n3000::reset']
      -> Exec["sriov-bind-device: ${title}"]
    }
    if ($device_id != undef) and ($device_id == '0d5c') {
      include platform::devices::acc100::fec
      Exec["sriov-enable-device: ${title}"]
      -> Class['platform::devices::acc100::fec']
    }
    ensure_resource(kmod::load, $driver)
    exec { "sriov-bind-device: ${title}":
      command   => template('platform/sriov.bind-device.erb'),
      logoutput => true,
      require   => [ Kmod::Load[$driver] ],
    }
  }
}

define platform::devices::sriov_vf_bind (
  $vf_config,
  $pf_config = undef,
) {
    create_resources('platform::devices::sriov_bind', $vf_config, {})
}

define platform::devices::sriov_pf_bind (
  $pf_config,
  $vf_config = undef
) {
  Platform::Devices::Sriov_pf_bind[$name] -> Platform::Devices::Sriov_pf_enable[$name]
  create_resources('platform::devices::sriov_bind', $pf_config, {})
}

define platform::devices::sriov_pf_enable (
  $pf_config,
  $vf_config = undef
) {
  create_resources('platform::devices::sriov_enable', $pf_config, {})
}

class platform::devices::fpga::fec::vf
  inherits ::platform::devices::fpga::fec::params {
  include ::platform::kubernetes::worker::sriovdp
  require ::platform::devices::fpga::fec::pf
  create_resources('platform::devices::sriov_vf_bind', $device_config, {})
  Platform::Devices::Sriov_vf_bind <| |> -> Class['platform::kubernetes::worker::sriovdp']
}

class platform::devices::fpga::fec::pf
  inherits ::platform::devices::fpga::fec::params {
  create_resources('platform::devices::sriov_pf_bind', $device_config, {})
  create_resources('platform::devices::sriov_pf_enable', $device_config, {})
}

class platform::devices::fpga::fec::runtime {
  include ::platform::devices::fpga::fec::config
}

class platform::devices::fpga::fec::params (
  $device_config = {}
) { }

class platform::devices::fpga::n3000::reset {
  # The N3000 FPGA is reset via docker container application by the
  # sysinv FPGA agent on startup.  This will clear the number of VFs
  # configured on the FEC device as well as any bound drivers.
  exec { 'Waiting for n3000 reset before enabling device':
    command   => 'test -e /var/run/.sysinv_n3000_reset',
    path      => '/usr/bin/',
    tries     => 60,
    try_sleep => 1,
    require   => Anchor['platform::networking'],
  }
}

class platform::devices::fpga::fec::config
  inherits ::platform::devices::fpga::fec::params {
  include platform::devices::fpga::fec::pf
  include platform::devices::fpga::fec::vf
}

class platform::devices::fpga::fec {
  Class[$name] -> Class['::sysinv::agent']
  require ::platform::devices::fpga::fec::config
}

class platform::devices::acc100::fec (
  $enabled = false
)
{
  if $enabled {
      exec { 'Mt.Bryce: Configuring baseband device':
        command   => template('platform/processing.accelerator-config.erb'),
        logoutput => true,
      }
  }
}

class platform::devices {
  include ::platform::devices::qat
  include ::platform::devices::fpga::fec
}
