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
class bcf::p_only::compute {

    include bcf
    include bcf::params

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
      notify            => Service['neutron-plugin-openvswitch-agent'],
    }
    ini_setting { 'neutron.conf agent_down_time':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'agent_down_time',
      value             => '150',
      notify            => Service['neutron-plugin-openvswitch-agent'],
    }
    ini_setting { 'neutron.conf service_plugins':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'service_plugins',
      value             => 'router',
      notify            => Service['neutron-plugin-openvswitch-agent'],
    }
    ini_setting { 'neutron.conf dhcp_agents_per_network':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'dhcp_agents_per_network',
      value             => '1',
      notify            => Service['neutron-plugin-openvswitch-agent'],
    }
    ini_setting { 'neutron.conf notification driver':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'notification_driver',
      value             => 'messaging',
      notify            => Service['neutron-plugin-openvswitch-agent'],
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
      notify            => Service['neutron-plugin-openvswitch-agent'],
    }
    ini_setting { 'ml2 tenant network types':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'ml2',
      key_val_separator => '=',
      setting           => 'tenant_network_types',
      value             => 'vlan',
      notify            => Service['neutron-plugin-openvswitch-agent'],
    }

    # change ml2 ownership
    file { '/etc/neutron/plugins/ml2':
      owner   => neutron,
      group   => neutron,
      recurse => true,
      notify  => Service['neutron-plugin-openvswitch-agent'],
    }

    # ensure neutron-plugin-openvswitch-agent is running
    file { '/etc/init/neutron-plugin-openvswitch-agent.conf':
      ensure => file,
      mode   => '0644',
    }
    service { 'neutron-plugin-openvswitch-agent':
      ensure     => 'running',
      enable     => true,
      provider   => 'upstart',
      hasrestart => true,
      hasstatus  => true,
      subscribe  => [File['/etc/init/neutron-plugin-openvswitch-agent.conf']],
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

    if $bcf::params::openstack::neutron_dvr {
      notice('MODULAR: bigswitch bcf::p_only::compute, dvr')
      service { 'neutron-l3-agent':
        ensure => running,
        enable => true,
      }

      # config /etc/neutron/l3-agent.ini
      ini_setting { 'l3 agent disable metadata proxy':
        ensure            => present,
        path              => '/etc/neutron/l3_agent.ini',
        section           => 'DEFAULT',
        key_val_separator => '=',
        setting           => 'enable_metadata_proxy',
        value             => 'False',
        notify            => Service['neutron-l3-agent'],
      }
      ini_setting { 'l3 agent external network bridge':
        ensure            => present,
        path              => '/etc/neutron/l3_agent.ini',
        section           => 'DEFAULT',
        key_val_separator => '=',
        setting           => 'external_network_bridge',
        value             => '',
        notify            => Service['neutron-l3-agent'],
      }
      ini_setting { 'l3 agent handle_internal_only_routers':
        ensure            => present,
        path              => '/etc/neutron/l3_agent.ini',
        section           => 'DEFAULT',
        key_val_separator => '=',
        setting           => 'handle_internal_only_routers',
        value             => 'True',
        notify            => Service['neutron-l3-agent'],
      }
    }
}
