#
#    Copyright 2015 BigSwitch Networks, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
notice('MODULAR: bigswitch p_v compute')
class bcf::p_v::compute {

    include bcf
    include bcf::params
    include bcf::params::openstack

    $interfaces_dict = $bcf::network_scheme['interfaces']
    notice("bigswitch interfaces_dict ${interfaces_dict}")
    $bridge_ips = {}
    $bridge_ips['br-aux'] = 'none'
    $ivs_internal_ports = {}

    $mgmt_ip = $bcf::existing_bridges['br-fw-admin']['IP']
    if has_key($bcf::existing_bridges, 'br-storage') {
        $bridge_ips['br-storage'] = $bcf::existing_bridges['br-storage']['IP']
        $ivs_internal_ports['br-storage'] = "sto${bcf::deployment_id}"
    }

    if has_key($bcf::existing_bridges, 'br-prv') {
        $bridge_ips['br-prv'] = $bcf::existing_bridges['br-prv']['IP']
    }

    if has_key($bcf::existing_bridges, 'br-mgmt') {
        $bridge_ips['br-mgmt'] = $bcf::existing_bridges['br-mgmt']['IP']
        $ivs_internal_ports['br-mgmt'] = "mgm${bcf::deployment_id}"
    }

    if has_key($bcf::existing_bridges, 'br-ex') {
        $bridge_ips['br-ex'] = $bcf::existing_bridges['br-ex']['IP']
        $ivs_internal_ports['br-ex'] = "ex${bcf::deployment_id}"
    }

    $bridge_list = split(inline_template("<%= @bridge_ips.keys.join(',') %>", ','))
    $interfaces = split(inline_template("<%= @interfaces_dict.keys.join(',') %>", ','))
    $internal_port_str = inline_template("<%= @ivs_internal_ports.values.join(' --internal-port=') %>")
    $ivs_uplink_str = regsubst($bcf::itfs, ',', ' -u ', 'G')

    notice("bigswitch bond_name ${bcf::bond_name}")
    notice("bigswitch interfaces ${interfaces}")

    # Install rootwrap filter
    file { '/etc/neutron/rootwrap.d/network.filters':
      ensure => 'file',
      source => 'puppet:///modules/bcf/rootwrap/network.filters',
    }
    file { '/etc/neutron/rootwrap.d/api-metadata.filters':
      ensure => 'file',
      source => 'puppet:///modules/bcf/rootwrap/api-metadata.filters',
    }
    file { '/etc/neutron/rootwrap.d/baremetal-deploy-helper.filters':
      ensure => 'file',
      source => 'puppet:///modules/bcf/rootwrap/baremetal-deploy-helper.filters',
    }
    file { '/etc/neutron/rootwrap.d/baremetal-compute-ipmi.filters':
      ensure => 'file',
      source => 'puppet:///modules/bcf/rootwrap/baremetal-compute-ipmi.filters',
    }
    file { '/etc/neutron/rootwrap.d/compute.filters':
      ensure => 'file',
      source => 'puppet:///modules/bcf/rootwrap/compute.filters',
    }

    package { 'python-pip':
      ensure  => 'installed',
      require => File['/etc/neutron/rootwrap.d/network.filters']
    }
    exec { 'bsnstacklib':
      command => 'pip install "bsnstacklib<2015.2"',
      path    => '/usr/local/bin/:/usr/bin/:/bin',
      require => Package['python-pip']
    }

    # Install the cleanup script
    file { '/etc/bigswitch':
      ensure  => 'directory',
      require => Exec['bsnstacklib']
    }
    file { '/etc/bigswitch/bridge-cleanup.sh':
      ensure  => 'file',
      source  => 'puppet:///modules/bcf/p_v/bridge-cleanup.sh',
      require => File['/etc/bigswitch']
    }
    exec { 'clean up ovs bridges':
      command   => "bash /etc/bigswitch/bridge-cleanup.sh ${bridge_list} ${bcf::bond_name}",
      path      => '/sbin:/usr/sbin/:/usr/local/bin/:/usr/bin/:/bin',
      logoutput => true,
      require   => File['/etc/bigswitch/bridge-cleanup.sh']
    }
    file { '/etc/bigswitch/ivs-install.sh':
      ensure  => 'file',
      source  => 'puppet:///modules/bcf/p_v/ivs-install.sh',
      require => EXEC['clean up ovs bridges']
    }
    exec { 'install ivs package':
      command   => "bash /etc/bigswitch/ivs-install.sh ${bcf::params::openstack::bcf_version}",
      path      => '/sbin:/usr/sbin/:/usr/local/bin/:/usr/bin/:/bin',
      logoutput => true,
      require   => File['/etc/bigswitch/ivs-install.sh']
    }
    file { '/etc/default/ivs':
      ensure  => file,
      mode    => '0644',
      content => "DAEMON_ARGS=\"--hitless --inband-vlan 4092 -u ${ivs_uplink_str} --internal-port=${internal_port_str}\"",
      require => Exec['install ivs package'],
      notify  => Service['ivs'],
    }

    service { 'ivs':
        ensure => running,
        enable => true,
    }

    file { '/etc/bigswitch/ivs-setup.sh':
      ensure  => 'file',
      source  => 'puppet:///modules/bcf/p_v/ivs-setup.sh',
      require => Service['ivs']
    }
    exec { 'set up ivs':
      command   => "bash /etc/bigswitch/ivs-setup.sh ${bcf::mgmt_itf} ${mgmt_ip} ${bcf::itfs} ${interfaces} \'${bridge_ips}\' ${bcf::deployment_id}",
      path      => '/sbin:/usr/sbin/:/usr/local/bin/:/usr/bin/:/bin',
      logoutput => true,
      require   => File['/etc/bigswitch/ivs-setup.sh']
    }

    # edit rc.local for cron job and default gw
    file { '/etc/rc.local':
      ensure => file,
      mode   => '0777',
    }->
    file_line { 'remove clear default gw':
      ensure => absent,
      path   => '/etc/rc.local',
      line   => 'ip route del default',
    }->
    file_line { 'remove ip route add default':
      ensure => absent,
      path   => '/etc/rc.local',
      line   => "ip route add default via ${bcf::gw}",
    }->
    file_line { 'clear default gw':
      path => '/etc/rc.local',
      line => 'ip route del default',
    }->
    file_line { 'add default gw':
      path => '/etc/rc.local',
      line => "ip route add default via ${bcf::gw}",
    }->
    file_line { 'add exit 0':
      path => '/etc/rc.local',
      line => 'exit 0',
    }

    exec { 'set default gw':
      command => "ip route del default; ip route add default via ${bcf::gw}",
      path    => '/usr/local/bin/:/usr/bin/:/bin:/sbin',
    }

    # config /etc/neutron/neutron.conf
    ini_setting { 'neutron.conf report_interval':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'agent',
      key_val_separator => '=',
      setting           => 'report_interval',
      value             => '60',
      notify            => Service['neutron-bsn-agent'],
    }
    ini_setting { 'neutron.conf agent_down_time':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'agent_down_time',
      value             => '150',
      notify            => Service['neutron-bsn-agent'],
    }
    ini_setting { 'neutron.conf service_plugins':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'service_plugins',
      value             => 'router',
      notify            => Service['neutron-bsn-agent'],
    }
    ini_setting { 'neutron.conf dhcp_agents_per_network':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'dhcp_agents_per_network',
      value             => '1',
      notify            => Service['neutron-bsn-agent'],
    }
    ini_setting { 'neutron.conf notification driver':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'notification_driver',
      value             => 'messaging',
      notify            => Service['neutron-bsn-agent'],
    }

    # set the correct properties in ml2_conf.ini on compute as well
    # config /etc/neutron/plugins/ml2/ml2_conf.ini
    ini_setting { 'ml2 type dirvers':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'ml2',
      key_val_separator => '=',
      setting           => 'type_drivers',
      value             => 'vlan',
      notify            => Service['neutron-bsn-agent'],
    }
    ini_setting { 'ml2 tenant network types':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'ml2',
      key_val_separator => '=',
      setting           => 'tenant_network_types',
      value             => 'vlan',
      notify            => Service['neutron-bsn-agent'],
    }

    # change ml2 ownership
    file { '/etc/neutron/plugins/ml2':
      owner   => neutron,
      group   => neutron,
      recurse => true,
      notify  => Service['neutron-bsn-agent'],
    }

    # config neutron-bsn-agent conf
    file { '/etc/init/neutron-bsn-agent.conf':
      ensure  => present,
      content => "
description \"Neutron BSN Agent\"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
script
    exec /usr/local/bin/neutron-bsn-agent --config-file=/etc/neutron/neutron.conf --config-file=/etc/neutron/plugin.ini --log-file=/var/log/neutron/neutron-bsn-agent.log
end script
",
    }
    file { '/etc/init.d/neutron-bsn-agent':
      ensure => link,
      target => '/lib/init/upstart-job',
      notify => Service['neutron-bsn-agent'],
    }

    service {'neutron-bsn-agent':
      ensure     => 'running',
      provider   => 'upstart',
      hasrestart => true,
      hasstatus  => true,
      subscribe  => [File['/etc/init/neutron-bsn-agent.conf'], File['/etc/init.d/neutron-bsn-agent']],
    }

    # stop and disable neutron-plugin-openvswitch-agent
    service { 'neutron-plugin-openvswitch-agent':
      ensure   => 'stopped',
      enable   => false,
      provider => 'upstart',
    }

    # disable l3 agent
    ini_setting { 'l3 agent disable metadata proxy':
      ensure            => present,
      path              => '/etc/neutron/l3_agent.ini',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'enable_metadata_proxy',
      value             => 'False',
    }
    file { '/etc/neutron/dnsmasq-neutron.conf':
      ensure  => file,
      content => 'dhcp-option-force=26,1400',
    }

    service { 'nova-compute':
      ensure => running,
      enable => true,
    }

    $public_ssl = hiera('public_ssl')
    $horizon_ssl = $public_ssl['horizon']
    if $horizon_ssl {
      $novnc_protocol = 'https'
    }
    else {
      $novnc_protocol = 'http'
    }

    # update nova.conf for novncproxy_base_url
    ini_setting { 'nova novncproxy_base_url':
      ensure            => present,
      path              => '/etc/nova/nova.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'novncproxy_base_url',
      value             => "${novnc_protocol}://${bcf::public_vip}:6080/vnc_auto.html",
      notify            => Service['nova-compute']
    }
}
