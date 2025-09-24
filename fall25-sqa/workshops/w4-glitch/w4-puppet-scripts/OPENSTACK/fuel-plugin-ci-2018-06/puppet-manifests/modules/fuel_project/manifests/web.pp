# Class: fuel_project::web
#
class fuel_project::web (
  $fuel_landing_page = false,
  $docs_landing_page = false,
) {
  class { '::fuel_project::nginx' :}
  class { '::fuel_project::common' :}


}
