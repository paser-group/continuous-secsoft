# Class: jenkins::slave
#
class jenkins::slave (
  $java_package = $::jenkins::params::slave_java_package,
  $authorized_keys = $::jenkins::params::slave_authorized_keys,
) inherits ::jenkins::params {
  ensure_packages([$java_package])

  if (!defined(User['jenkins'])) {
    user { 'jenkins' :
      ensure     => 'present',
      name       => 'jenkins',
      shell      => '/bin/bash',
      home       => '/home/jenkins',
      managehome => true,
      system     => true,
      comment    => 'Jenkins',
    }
  }

  create_resources(ssh_authorized_key, $authorized_keys, {
    ensure  => 'present',
    user    => 'jenkins',
    require => [
      User['jenkins'],
      Package[$java_package],
    ],
  })
}
