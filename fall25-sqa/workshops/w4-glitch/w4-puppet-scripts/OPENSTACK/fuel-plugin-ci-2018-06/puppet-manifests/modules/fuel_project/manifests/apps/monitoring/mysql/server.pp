# Class: fuel_project::apps::monitoring::mysql::server
#
class fuel_project::apps::monitoring::mysql::server {
  zabbix::item { 'mysql' :
    content => 'puppet:///modules/fuel_project/apps/monitoring/mysql/mysql_items.conf',
  }

  file { '/var/lib/zabbix/.my.cnf' :
    ensure  => 'present',
    source  => '/root/.my.cnf',
    require => Class['::mysql::server'],
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0600',
  }
}
