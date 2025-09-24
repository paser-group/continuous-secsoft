#
# puppet manifest for worker nodes
#

Exec {
  timeout => 300,
  path => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin:/usr/local/sbin'
}

include ::platform::config
include ::platform::users
include ::platform::sysctl::compute
include ::platform::dhclient
include ::platform::partitions
include ::platform::lvm::compute
include ::platform::compute
include ::platform::vswitch
include ::platform::network
include ::platform::fstab
include ::platform::password
include ::platform::ldap::client
include ::platform::ntp::client
include ::platform::ptp
include ::platform::lldp
include ::platform::patching
include ::platform::remotelogging
include ::platform::mtce
include ::platform::sysinv
include ::platform::devices
include ::platform::interfaces::sriov
include ::platform::grub
include ::platform::collectd
include ::platform::filesystem::compute
include ::platform::docker::worker
include ::platform::containerd::worker
include ::platform::dockerdistribution::compute
include ::platform::docker::login
include ::platform::kubernetes::worker
include ::platform::multipath
include ::platform::client
include ::platform::ceph::worker
include ::platform::worker::storage
include ::platform::pciirqaffinity
include ::platform::lmon
include ::platform::rook

class { '::platform::config::worker::post':
  stage => post,
}

hiera_include('classes')
