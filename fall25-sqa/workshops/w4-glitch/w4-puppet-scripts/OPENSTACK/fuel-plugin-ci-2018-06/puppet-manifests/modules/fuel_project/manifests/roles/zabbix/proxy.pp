# Class: fuel_project::roles::zabbix::proxy
#
class fuel_project::roles::zabbix::proxy {
  class { '::fuel_project::common' :}
  class { '::zabbix::proxy' :}
}
