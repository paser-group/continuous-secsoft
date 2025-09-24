# Class: uwsgi::params
#
class uwsgi::params {
  $package = 'uwsgi'
  $service = 'uwsgi'

  # Plugins
  $plugins_packages = {
    'python' => [
      'uwsgi-plugin-python',
    ],
    'rack' => [
      'uwsgi-plugin-rack-ruby1.9.1',
      'ruby-rack',
    ]
  }

  $somaxconn      = 65535

  $buffer_size    = 65535
  $callable       = undef
  $chdir          = '/'
  $chmod          = 644
  $enable_threads = true
  $env            = undef
  $gid            = 'www-data'
  $home           = undef
  $listen         = 1000
  $master         = true
  $module         = undef
  $plugins        = undef
  $rack           = undef
  $socket         = undef
  $uid            = 'www-data'
  $vacuum         = true
  $workers        = $::processorcount
}
