# Class: fuel_project::nginx
#
class fuel_project::nginx {
  if (!defined(Class['::nginx'])) {
    class { '::nginx' :}
  }

  
}