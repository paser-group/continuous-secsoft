# = Class: zaqar::server_instance
#
# This class manages N instances of zaqar-server each using an
# alternate /etc/zaqar/n.conf file to control select service
# settings which take priority over settings in /etc/zaqar/zaqar.conf.
#
# [*transport*]
#  Set to either 'wsgi' or 'websocket'. Required.
#
# [*enabled*]
#   (Optional) Service enable state for zaqar-server.
#   Defaults to true
#
define zaqar::server_instance(
  $transport,
  $enabled = true,
) {

  include ::zaqar
  include ::zaqar::deps
  include ::zaqar::params

  if $enabled {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  file { "/etc/zaqar/${name}.conf":
    ensure  => file,
    content => template('zaqar/zaqar.conf.erb'),
  }

  service { "${::zaqar::params::service_name}@${name}":
    ensure => $service_ensure,
    enable => $enabled,
    tag    => 'zaqar-service'
  }

  Package['zaqar-common'] ~> File["/etc/zaqar/${name}.conf"]
  File["/etc/zaqar/${name}.conf"] ~> Service["${::zaqar::params::service_name}@${name}"]

}
