# The puppet configure ScaleIO MDM IPs in environment for existing ScaleIO cluster.

#TODO: move it from this file and from environment.pp into modules
define env_fact($role, $fact, $value) {
  file_line { "Append a SCALEIO_${role}_${fact} line to /etc/environment":
    ensure => present,
    path   => '/etc/environment',
    match  => "^SCALEIO_${role}_${fact}=",
    line   => "SCALEIO_${role}_${fact}=${value}",
  }
}

notice('MODULAR: scaleio: environment_existing_mdm_ips')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if $scaleio['existing_cluster'] {
    $ips = $::scaleio_mdm_ips_from_gateway
    if ! $ips or $ips == '' {
      fail('Cannot request MDM IPs from existing cluster. Check Gateway address/port and user name with password.')
    }
    env_fact{"Environment fact: role mdm, ips from existing cluster ${ips}":
      role  => 'controller',
      fact  => 'ips',
      value => $ips
    }
  }
} else {
    notify{'ScaleIO plugin disabled': }
}
