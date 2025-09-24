# Define: uwsgi::application
#
define uwsgi::application (
  $buffer_size    = $::uwsgi::params::buffer_size,
  $callable       = $::uwsgi::params::callable,
  $chdir          = $::uwsgi::params::chdir,
  $chmod          = $::uwsgi::params::chmod,
  $enable_threads = $::uwsgi::params::enable_threads,
  $env            = $::uwsgi::params::env,
  $gid            = $::uwsgi::params::gid,
  $home           = $::uwsgi::params::home,
  $listen         = $::uwsgi::params::listen,
  $master         = $::uwsgi::params::master,
  $module         = $::uwsgi::params::module,
  $plugins        = $::uwsgi::params::plugins,
  $rack           = $::uwsgi::params::rack,
  $socket         = $::uwsgi::params::socket,
  $uid            = $::uwsgi::params::uid,
  $vacuum         = $::uwsgi::params::vacuum,
  $workers        = $::uwsgi::params::workers,
) {
  if (!defined(Class['::uwsgi'])) {
    class { '::uwsgi' :}
  }

  ensure_packages($::uwsgi::params::plugins_packages[$plugins])

  file { "/etc/uwsgi/apps-available/${title}.yaml" :
    ensure  => 'present',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('uwsgi/application.yaml.erb'),
    require => [
      Package[$::uwsgi::params::package],
      Package[$::uwsgi::params::plugins_packages[$plugins]],
    ],
    notify  => Service[$::uwsgi::params::service],
  }->
  file { "/etc/uwsgi/apps-enabled/${title}.yaml" :
    ensure => 'link',
    target => "/etc/uwsgi/apps-available/${title}.yaml",
    notify => Service[$::uwsgi::params::service],
  }
}
