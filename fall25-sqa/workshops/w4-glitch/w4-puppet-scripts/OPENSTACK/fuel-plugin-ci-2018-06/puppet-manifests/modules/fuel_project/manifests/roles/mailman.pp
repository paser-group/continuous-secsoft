# Class: fuel_project::roles::mailman
#
class fuel_project::roles::mailman {
  class { '::fuel_project::common' :}
  class { '::fuel_project::nginx' :}
  class { '::mailman' :}
  class { '::apache' :}
  class { '::apache::mod::cgid' :}
  class { '::apache::mod::mime' :}

  ::apache::vhost { $::fqdn :
    docroot     => '/var/www/lists',
    aliases     => hiera_array('fuel_project::roles::mailman::apache_aliases'),
    directories => hiera_array('fuel_project::roles::mailman::apache_directories'),
  }
}
