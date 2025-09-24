#
# Copyright 2016 6WIND S.A.

class virtual_accelerator::service inherits virtual_accelerator {

  service { 'virtual-accelerator':
      ensure => 'running',
      notify => Service['openvswitch-switch'],
  }

  service { 'openvswitch-switch':
      ensure => 'running',
      notify => Service['neutron-openvswitch-agent'],
  }

  service { 'neutron-openvswitch-agent':
      ensure => 'running',
  }

  # Let's make sure to use the default hugetlbfs mount point (that could have
  # been modified by Fuel)
  exec { 'disable_custom_hugepages_dir_qemu':
      command => "sed -i 's~^hugetlbfs_mount =~#hugetlbfs_mount =~' /etc/libvirt/qemu.conf",
      notify => Service['libvirt-bin'],
  }

  service { 'libvirt-bin':
      ensure => 'stopped',
      notify => Service['libvirtd'],
  }

  service { 'libvirtd':
      ensure => 'running',
      notify => Service['nova-compute'],
  }

  service { 'nova-compute':
      ensure => 'running',
  }

}
