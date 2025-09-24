class platform::lmon::params(
  $data_iface_devices = [],
) { }

class platform::lmon
  inherits ::platform::lmon::params {

  include ::platform::params
  include ::platform::network::mgmt::params
  include ::platform::network::oam::params
  include ::platform::network::cluster_host::params
  include ::platform::kubernetes::params

  # dependent template variables
  $management_interface = $::platform::network::mgmt::params::interface_name
  $cluster_host_interface = $::platform::network::cluster_host::params::interface_name
  $oam_interface = $::platform::network::oam::params::interface_name
  $host_labels = $::platform::kubernetes::params::host_labels

  $data_interface = length($data_iface_devices) > 0
                        and !('openstack-compute-node'
                            in $host_labels)
  $data_interface_str = join($data_iface_devices,',')

  $lmon_conf = '/etc/lmon/lmon.conf'

  file { '/etc/lmon':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { $lmon_conf:
        ensure  => present,
        content => template('platform/lmon.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
  }

}
