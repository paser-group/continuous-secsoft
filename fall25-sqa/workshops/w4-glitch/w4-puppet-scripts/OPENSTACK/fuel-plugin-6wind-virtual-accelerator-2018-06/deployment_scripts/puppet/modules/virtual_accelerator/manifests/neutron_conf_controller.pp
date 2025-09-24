#
# Copyright 2016 6WIND S.A.

class virtual_accelerator::neutron_conf_controller inherits virtual_accelerator {

  $disable_secgroup = $virtual_accelerator::disable_secgroup

  if $disable_secgroup == true {
      $OVS_CONF_FILE = "/etc/neutron/plugins/ml2/ml2_conf.ini"

      package { 'crudini':
         ensure => 'latest',
         notify => Exec['disable_firewall'],
      }

      exec { 'disable_firewall':
         command => "crudini --set ${OVS_CONF_FILE} securitygroup firewall_driver noop",
         notify => Service['neutron-server'],
      }

      service { 'neutron-server':
         ensure => 'running',
      }
  }

}
