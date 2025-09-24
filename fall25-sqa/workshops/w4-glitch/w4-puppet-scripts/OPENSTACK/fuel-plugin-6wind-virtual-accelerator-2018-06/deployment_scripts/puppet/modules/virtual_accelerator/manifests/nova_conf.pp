#
# Copyright 2016 6WIND S.A.

class virtual_accelerator::nova_conf inherits virtual_accelerator {

  $NOVA_CONF_FILE = "/etc/nova/nova.conf"
  $enable_host_cpu = $virtual_accelerator::enable_host_cpu
  $disable_secgroup = $virtual_accelerator::disable_secgroup

  if $enable_host_cpu == true {
    exec { 'cpu_host':
        command => "crudini --set ${NOVA_CONF_FILE} libvirt cpu_mode host-passthrough",
        notify => Package['6wind-openstack-extensions'],
    }
  }

  package { "6wind-openstack-extensions":
    ensure   => 'installed',
    install_options => ['--allow-unauthenticated'],
  }

  if $disable_secgroup == true {
    exec { 'disable_secgroup':
        command => "crudini --del ${NOVA_CONF_FILE} DEFAULT security_group_api",
        notify => Exec['vcpu_pin'],
    }
  }

  exec { 'vcpu_pin':
      command => "crudini --set ${NOVA_CONF_FILE} DEFAULT vcpu_pin_set $(python /usr/local/bin/get_vcpu_pin_set.py)",
  }

}

