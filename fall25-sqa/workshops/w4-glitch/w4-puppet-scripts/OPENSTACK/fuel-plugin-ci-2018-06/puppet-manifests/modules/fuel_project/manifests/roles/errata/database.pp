# Class: fuel_project::roles::errata::database
#
class fuel_project::roles::errata::database {
  if (!defined(Class['::fuel_project::common'])) {
    class { '::fuel_project::common' :}
  }
  class { '::errata::database' :}
}
