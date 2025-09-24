class nsxt::create_repo (
  $managers,
  $username,
  $password,
  $repo_dir       = '/opt/nsx-t-repo',
  $repo_file      = '/etc/apt/sources.list.d/nsx-t-local.list',
  $repo_pref_file = '/etc/apt/preferences.d/nsx-t-local.pref',
) {
  $component_archive = get_nsxt_components($managers, $username, $password)

  file { '/tmp/create_repo.sh':
    ensure  => file,
    mode    => '0755',
    source  => "puppet:///modules/${module_name}/create_repo.sh",
    replace => true,
  }
  file { $repo_file:
    ensure  => file,
    mode    => '0644',
    content => "deb file:${repo_dir} /",
    replace => true,
  }
  file { $repo_pref_file:
    ensure  => file,
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/pinning",
    replace => true,
  }
  exec { 'Create repo':
    path     => '/usr/sbin:/usr/bin:/sbin:/bin',
    command  => "/tmp/create_repo.sh ${repo_dir} ${component_archive}",
    provider => 'shell',
    require  => File['/tmp/create_repo.sh'],
  }
}
