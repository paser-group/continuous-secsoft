# Class: fuel_project::jenkins::slave::custom_scripts

class fuel_project::jenkins::slave::custom_scripts (
  $docker_package,
  $configs_path = '/etc/custom_scripts/',
  $docker_user  = 'jenkins',
  $known_hosts  = undef,
  $packages     = [
    'git',
  ],
) {

  $configs = hiera_hash('fuel_project::jenkins::slave::custom_scripts::configs', {})

  if (!defined(Class['::fuel_project::common'])) {
    class { '::fuel_project::common' : }
  }

  if (!defined(Class['::jenkins::slave'])) {
    class { '::jenkins::slave' : }
  }

  # install required packages
  ensure_packages($packages)
  ensure_packages($docker_package)

  # ensure $docker_user in docker group
  # docker group will be created by docker package
  User <| title == $docker_user |> {
    groups  +> 'docker',
    require => Package[$docker_package],
  }

  if ($known_hosts) {
    create_resources('ssh::known_host', $known_hosts, {
      user      => $docker_user,
      overwrite => false,
      require   => User[$docker_user],
    })

  }

  if ($configs) {
    file { $configs_path:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }

    create_resources(file, $configs, {
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      require => File[$configs_path],
    })

  }

}
