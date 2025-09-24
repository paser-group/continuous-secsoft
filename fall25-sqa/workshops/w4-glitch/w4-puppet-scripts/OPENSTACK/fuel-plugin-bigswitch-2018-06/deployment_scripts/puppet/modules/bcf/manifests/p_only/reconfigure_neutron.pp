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
class bcf::p_only::reconfigure_neutron {

    include bcf
    include bcf::params
    include bcf::params::openstack
    $binpath = '/usr/local/bin/:/bin/:/usr/bin:/usr/sbin:/usr/local/sbin:/sbin'

    package { 'python-pip':
      ensure => 'installed',
    }
    exec { 'bsnstacklib':
      command => 'pip install "bsnstacklib<2015.2"',
      path    => '/usr/local/bin/:/usr/bin/:/bin',
      require => Package['python-pip']
    }

    # purge bcf controller public key
    exec { 'purge bcf key':
        command => 'rm -rf /etc/neutron/plugins/ml2/host_certs/*',
        path    => $binpath,
        notify  => Service['neutron-server'],
    }

    # config /etc/neutron/neutron.conf
    ini_setting { 'neutron.conf report_interval':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'agent',
      key_val_separator => '=',
      setting           => 'report_interval',
      value             => '60',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'neutron.conf agent_down_time':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'agent_down_time',
      value             => '150',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'neutron.conf service_plugins':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'service_plugins',
      value             => 'router',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'neutron.conf dhcp_agents_per_network':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'dhcp_agents_per_network',
      value             => '1',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'neutron.conf network_scheduler_driver':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'network_scheduler_driver',
      value             => 'neutron.scheduler.dhcp_agent_scheduler.WeightScheduler',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'neutron.conf notification driver':
      ensure            => present,
      path              => '/etc/neutron/neutron.conf',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'notification_driver',
      value             => 'messaging',
      notify            => Service['neutron-server'],
    }

    # config /etc/neutron/plugin.ini
    ini_setting { 'neutron plugin.ini firewall_driver':
      ensure            => present,
      path              => '/etc/neutron/plugin.ini',
      section           => 'securitygroup',
      key_val_separator => '=',
      setting           => 'firewall_driver',
      value             => 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'neutron plugin.ini enable_security_group':
      ensure            => present,
      path              => '/etc/neutron/plugin.ini',
      section           => 'securitygroup',
      key_val_separator => '=',
      setting           => 'enable_security_group',
      value             => 'True',
      notify            => Service['neutron-server'],
    }
    file { '/etc/neutron/dnsmasq-neutron.conf':
      ensure  => file,
      content => 'dhcp-option-force=26,1400',
    }

    # config /etc/neutron/l3-agent.ini
    ini_setting { 'l3 agent disable metadata proxy':
      ensure            => present,
      path              => '/etc/neutron/l3_agent.ini',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'enable_metadata_proxy',
      value             => 'False',
    }
    ini_setting { 'l3 agent external network bridge':
      ensure            => present,
      path              => '/etc/neutron/l3_agent.ini',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'external_network_bridge',
      value             => '',
    }
    ini_setting { 'l3 agent handle_internal_only_routers':
      ensure            => present,
      path              => '/etc/neutron/l3_agent.ini',
      section           => 'DEFAULT',
      key_val_separator => '=',
      setting           => 'handle_internal_only_routers',
      value             => 'True',
    }

    # config /etc/neutron/plugins/ml2/ml2_conf.ini
    ini_setting { 'ml2 type dirvers':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'ml2',
      key_val_separator => '=',
      setting           => 'type_drivers',
      value             => 'vlan',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 tenant network types':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'ml2',
      key_val_separator => '=',
      setting           => 'tenant_network_types',
      value             => 'vlan',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 mechanism drivers':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'ml2',
      key_val_separator => '=',
      setting           => 'mechanism_drivers',
      value             => 'openvswitch,bsn_ml2',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy ssl cert directory':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'ssl_cert_directory',
      value             => '/etc/neutron/plugins/ml2',
      notify            => Service['neutron-server'],
    }
    if $bcf::params::openstack::bcf_controller_2 == '' {
        $server = "${bcf::params::openstack::bcf_controller_1}:8000"
    }
    else {
        $server = "${bcf::params::openstack::bcf_controller_1}:8000,${bcf::params::openstack::bcf_controller_2}:8000"
    }

    ini_setting { 'ml2 restproxy servers':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'servers',
      value             => $server,
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy server auth':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'server_auth',
      value             => "${bcf::params::openstack::bcf_username}:${bcf::params::openstack::bcf_password}",
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy server ssl':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'server_ssl',
      value             => 'True',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy auto sync on failure':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'auto_sync_on_failure',
      value             => 'True',
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy consistency interval':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'consistency_interval',
      value             => 60,
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy neutron_id':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'neutron_id',
      value             => "${bcf::params::openstack::bcf_instance_id}",
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy auth_url':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'auth_url',
      value             => "http://${bcf::params::openstack::keystone_vip}:35357",
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy auth_user':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'auth_user',
      value             => "${bcf::params::openstack::auth_user}",
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy auth_password':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'auth_password',
      value             => "${bcf::params::openstack::auth_password}",
      notify            => Service['neutron-server'],
    }
    ini_setting { 'ml2 restproxy auth_tenant_name':
      ensure            => present,
      path              => '/etc/neutron/plugins/ml2/ml2_conf.ini',
      section           => 'restproxy',
      key_val_separator => '=',
      setting           => 'auth_tenant',
      value             => "${bcf::params::openstack::auth_tenant_name}",
      notify            => Service['neutron-server'],
    }

    # change ml2 ownership
    file { '/etc/neutron/plugins/ml2':
      owner   => neutron,
      group   => neutron,
      recurse => true,
      notify  => Service['neutron-server'],
    }

    # neutron-server, keystone
    service { 'neutron-server':
      ensure => running,
      enable => true,
    }
}
