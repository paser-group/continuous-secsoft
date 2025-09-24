# Class: fuel_project::roles::tracker
#
class fuel_project::roles::tracker {
  class { '::fuel_project::common' :}
  class { '::opentracker' :}
}
