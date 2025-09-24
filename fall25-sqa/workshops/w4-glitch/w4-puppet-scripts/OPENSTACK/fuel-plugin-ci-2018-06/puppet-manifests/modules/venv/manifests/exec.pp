# Define: venv::exec
# This class provides exec command interface inside defined environment.
# Provides all exec functionalities (like cwd and onlyif).

define venv::exec (
  $command,
  $venv,
  $cwd    = '/tmp',
  $onlyif = '/bin/true',
  $user   = 'nobody',
) {

  ensure_packages(['python-virtualenv'])

  exec { "${user}@${venv}:${cwd} exec ${command}" :
    command   => "HOME='/home/${user}' ; \
      . ${venv}/bin/activate ; ${command}",
    user      => $user,
    cwd       => $cwd,
    logoutput => on_failure,
    onlyif    => $onlyif,
  }
}
