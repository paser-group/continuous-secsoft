# Class: fuel_project::roles::perestroika::builder
#
# jenkins slave host for building packages
# see hiera file for list and params of used classes

class fuel_project::roles::perestroika::builder (
  $docker_package,
  $builder_user = 'jenkins',
  $known_hosts  = undef,
  $packages     = [
    'createrepo',
    'devscripts',
    'git',
    'python-setuptools',
    'reprepro',
    'yum-utils',
  ],
){

  # ensure build user exists
  ensure_resource('user', $builder_user, {
    'ensure' => 'present'
  })

  # install required packages
  ensure_packages($packages)
  ensure_packages($docker_package)

  # ensure $builder_user in docker group
  # docker group will be created by docker package
  User <| title == $builder_user |> {
    groups  +> 'docker',
    require => Package[$docker_package],
  }

  if ($known_hosts) {
    create_resources('ssh::known_host', $known_hosts, {
      user      => $builder_user,
      overwrite => false,
      require   => User[$builder_user],
    })
  }

}
