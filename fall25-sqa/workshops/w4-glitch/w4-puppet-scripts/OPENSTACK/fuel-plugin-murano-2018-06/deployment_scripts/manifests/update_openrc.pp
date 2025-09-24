notice('MURANO PLUGIN: update_openrc.pp')

$murano_hash     = hiera_hash('murano_plugin', {})
$murano_plugins  = $murano_hash['plugins']
$murano_repo_url = $murano_hash['murano_repo_url']

$operator_user_hash    = hiera_hash('operator_user', {})
$service_user_hash     = hiera_hash('service_user', {})
$operator_user_name    = pick($operator_user_hash['name'], 'fueladmin')
$operator_user_homedir = pick($operator_user_hash['homedir'], '/home/fueladmin')
$service_user_name     = pick($service_user_hash['name'], 'fuel')
$service_user_homedir  = pick($service_user_hash['homedir'], '/var/lib/fuel')

file_line { 'murano_repo_url root':
  line  => "export MURANO_REPO_URL=\'${murano_repo_url}\'",
  match => '^export\ MURANO_REPO_URL\=',
  path  => '/root/openrc',
}

file_line { "murano_repo_url ${operator_user_name}":
  line  => "export MURANO_REPO_URL=\'${murano_repo_url}\'",
  match => '^export\ MURANO_REPO_URL\=',
  path  => "${operator_user_homedir}/openrc",
}

file_line { "murano_repo_url ${service_user_name}":
  line  => "export MURANO_REPO_URL=\'${murano_repo_url}\'",
  match => '^export\ MURANO_REPO_URL\=',
  path  => "${service_user_homedir}/openrc",
}

if has_key($murano_plugins, 'glance_artifacts_plugin') and $murano_plugins['glance_artifacts_plugin']['enabled'] {
  file_line { 'murano_glare_plugin root':
    line  => "export MURANO_PACKAGES_SERVICE='glare'",
    match => '^export\ MURANO_PACKAGES_SERVICE\=',
    path  => '/root/openrc',
  }

  file_line { "murano_glare_plugin ${operator_user_name}":
    line  => "export MURANO_PACKAGES_SERVICE='glare'",
    match => '^export\ MURANO_PACKAGES_SERVICE\=',
    path  => "${operator_user_homedir}/openrc",
  }

  file_line { "murano_glare_plugin ${service_user_name}":
    line  => "export MURANO_PACKAGES_SERVICE='glare'",
    match => '^export\ MURANO_PACKAGES_SERVICE\=',
    path  => "${service_user_homedir}/openrc",
  }
} else {
  file_line { 'murano_glare_plugin':
    ensure            => absent,
    line              => "export MURANO_PACKAGES_SERVICE=",
    replace           => false,
    match             => "^export\ MURANO_PACKAGES_SERVICE\='(glance|glare)'",
    match_for_absence => true,
    path              => '/root/openrc',
  }

  file_line { "murano_glare_plugin ${operator_user_name}":
    ensure            => absent,
    line              => "export MURANO_PACKAGES_SERVICE=",
    replace           => false,
    match             => "^export\ MURANO_PACKAGES_SERVICE\='(glance|glare)'",
    match_for_absence => true,
    path              => "${operator_user_homedir}/openrc",
  }

  file_line { "murano_glare_plugin ${service_user_name}":
    ensure            => absent,
    line              => "export MURANO_PACKAGES_SERVICE=",
    replace           => false,
    match             => "^export\ MURANO_PACKAGES_SERVICE\='(glance|glare)'",
    match_for_absence => true,
    path              => "${service_user_homedir}/openrc",
  }
}
