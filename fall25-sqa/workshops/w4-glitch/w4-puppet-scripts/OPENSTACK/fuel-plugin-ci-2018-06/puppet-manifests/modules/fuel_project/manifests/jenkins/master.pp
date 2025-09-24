# Class: fuel_project::jenkins::master
#
class fuel_project::jenkins::master (
  $firewall_enable      = false,
  $install_label_dumper = false,
  $install_plugins      = false,
  $install_zabbix_item  = false,
  $service_fqdn         = $::fqdn,
) {
  class { '::fuel_project::common':
    external_host => $firewall_enable,
  }
  class { '::jenkins::master':
    apply_firewall_rules => $firewall_enable,
    install_zabbix_item  => $install_zabbix_item,
    install_label_dumper => $install_label_dumper,
    service_fqdn         => $service_fqdn,
  }
  if($install_plugins) {
    package { 'jenkins-plugins' :
      ensure  => present,
      require => Service['jenkins'],
    }
  }
}
