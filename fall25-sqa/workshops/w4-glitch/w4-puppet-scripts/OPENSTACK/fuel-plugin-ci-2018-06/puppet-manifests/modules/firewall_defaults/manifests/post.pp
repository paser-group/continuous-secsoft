# Class: firewall_defaults::post
#
class firewall_defaults::post {
  firewall { '9999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }
}
