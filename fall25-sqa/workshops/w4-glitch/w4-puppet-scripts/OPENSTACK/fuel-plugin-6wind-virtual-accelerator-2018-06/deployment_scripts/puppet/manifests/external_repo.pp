#
# Copyright 2016 6WIND S.A.

notice('MODULAR: virtual_accelerator/external_repo.pp')

$settings = hiera('6wind-virtual-accelerator', {})
$ext_pack = $settings['ext_pack']

if $ext_pack == true {

    exec { 'add_6wind_ppa':
      command => '/usr/bin/add-apt-repository -y ppa:6wind/virt-mq-current',
    } ->
    file { '/etc/apt/preferences.d/6wind-ppa.pref':
      owner   => 'root',
      group   => 'root',
      mode    => 0644,
      source => 'puppet:///modules/virtual_accelerator/6wind-ppa.pref',
    } ->
    exec { 'update_repos':
      command => '/usr/bin/apt-get -y update',
    } ->
    package { 'libvirt-bin':
      ensure => 'latest',
    } ->
    file { '/etc/default/libvirtd':
      ensure => 'link',
      target => '/etc/default/libvirt-bin',
    } ->
    file { '/etc/init/libvirtd.conf':
      ensure => 'link',
      target => '/etc/init/libvirt-bin.conf',
    } ->
    file { '/etc/init.d/libvirtd':
      ensure => 'link',
      target => '/etc/init.d/libvirt-bin',
    } ->
    exec { 'libvirt_bin_manual':
      command => '/bin/echo manual > /etc/init/libvirt-bin.override',
    } ->
    package { 'python-libvirt':
      ensure => 'latest',
    } ->
    package { 'qemu':
      ensure => 'latest',
    } ->
    package { 'qemu-system-x86':
      ensure => 'latest',
    } ->
    # workaround for bug https://bugs.launchpad.net/fuel/+bug/1603446 in Fuel 8
    group { 'libvirt':
      ensure => 'present',
    }

}
