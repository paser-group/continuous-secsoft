#
# Copyright 2016 6WIND S.A.

class virtual_accelerator::neutron_conf_compute inherits virtual_accelerator {

  $disable_secgroup = $virtual_accelerator::disable_secgroup

  if $disable_secgroup == true {
      $OVS_CONF_FILE = "/etc/neutron/plugins/ml2/openvswitch_agent.ini"

      package { 'crudini':
         ensure => 'latest',
      }

      exec { 'disable_secgroup':
         command => "crudini --set ${OVS_CONF_FILE} securitygroup enable_security_group False",
      } ->
      exec { 'disable_firewall':
         command => "crudini --set ${OVS_CONF_FILE} securitygroup firewall_driver noop",
         notify => Service['openvswitch-switch'],
      }

      service { 'openvswitch-switch':
         ensure => 'running',
         notify => Service['neutron-openvswitch-agent'],
      }

      service { 'neutron-openvswitch-agent':
         ensure => 'running',
      }
  }

}
