# Define: ssh::known_host
#
define ssh::known_host (
  $host      = $title,
  $overwrite = true,
  $port      = 22,
  $user      = 'root',
) {
  if ($overwrite) {
    $cmd = "ssh-keyscan -p ${port} -H ${host} > ~${user}/.ssh/known_hosts"
    $unless = '/bin/false'
  } else {
    $cmd = "ssh-keyscan -p ${port} -H ${host} >> ~${user}/.ssh/known_hosts"
    $unless = "ssh-keygen -F ${host} -f ~${user}/.ssh/known_hosts"
  }
  exec { $cmd:
    user      => $user,
    logoutput => 'on_failure',
    unless    => $unless,
  }
}
