# Define: venv::venv
#
define venv::venv (
  $path,
  $options      = '',
  $packages     = [],
  $pip_opts     = '',
  $requirements = '',
  $user         = 'root',
) {


  $venv_packages = [
    'git',
    'python-dev',
    'python-virtualenv',
  ]

  ensure_packages($venv_packages)
  ensure_packages($packages)

  exec { "virtualenv ${options} ${path}" :
    command   => "virtualenv ${options} ${path}",
    creates   => $path,
    user      => $user,
    logoutput => on_failure,
    require   => [
      Package['python-virtualenv'],
    ],
  }

  if $requirements {
    exec { ". ${path}/bin/activate ; pip install -r ${requirements}" :
      command   => "export HOME='/home/${user}' ; \
        . ${path}/bin/activate ; pip install ${pip_opts} -r ${requirements}",
      user      => $user,
      cwd       => $path,
      logoutput => on_failure,
      require   => [
        Exec["virtualenv ${options} ${path}"],
        Package[$packages],
      ],
    }
  }
}
