class platform::helm::repositories::params(
  $source_helm_repos_base_dir = '/opt/platform/helm_charts',
  $target_helm_repos_base_dir = '/www/pages/helm_charts',
  $helm_repositories = [ 'stx-platform', 'starlingx' ],
) {}

define platform::helm::repository (
  $repo_base = undef,
  $repo_port = undef,
  $create = false,
) {

  $repo_path = "${repo_base}/${name}"

  if str2bool($create) {
    file {$repo_path:
      ensure  => directory,
      path    => $repo_path,
      owner   => 'www',
      require => User['www'],
    }

    -> exec { "Generate index: ${repo_path}":
      command   => "helm repo index ${repo_path}",
      logoutput => true,
      user      => 'www',
      group     => 'root',
      require   => User['www'],
    }

    $before_relationship = Exec['Stop lighttpd']
    $require_relationship =  [ User['sysadmin'], Exec["Generate index: ${repo_path}"] ]
  } else {
    $before_relationship = undef
    $require_relationship =  User['sysadmin']
  }

  exec { "Adding StarlingX helm repo: ${name}":
    before      => $before_relationship,
    environment => [ 'KUBECONFIG=/etc/kubernetes/admin.conf' , 'HOME=/home/sysadmin'],
    command     => "helm repo add ${name} http://127.0.0.1:${repo_port}/helm_charts/${name}",
    logoutput   => true,
    user        => 'sysadmin',
    group       => 'sys_protected',
    require     => $require_relationship
  }
}

class platform::helm::repositories
  inherits ::platform::helm::repositories::params {
  include ::openstack::horizon::params
  include ::platform::users

  Anchor['platform::services']

  -> platform::helm::repository { $helm_repositories:
    repo_base => $target_helm_repos_base_dir,
    repo_port => $::openstack::horizon::params::http_port,
    create    => $::is_initial_config,
  }

  -> exec { 'Updating info of available charts locally from chart repo':
    environment => [ 'KUBECONFIG=/etc/kubernetes/admin.conf', 'HOME=/home/sysadmin' ],
    command     => 'helm repo update',
    logoutput   => true,
    user        => 'sysadmin',
    group       => 'sys_protected',
    require     => User['sysadmin']
  }
}

class platform::helm
  inherits ::platform::helm::repositories::params {

  include ::platform::docker::params

  file {$target_helm_repos_base_dir:
    ensure  => directory,
    path    => $target_helm_repos_base_dir,
    owner   => 'www',
    require => User['www']
  }

  Drbd::Resource <| |>

  -> file {$source_helm_repos_base_dir:
    ensure  => directory,
    path    => $source_helm_repos_base_dir,
    owner   => 'www',
    require => User['www']
  }

  if (str2bool($::is_initial_config) and $::personality == 'controller') {
    include ::platform::helm::repositories

    Class['::platform::kubernetes::master']

    -> exec { 'restart lighttpd for helm':
      require   => [File['/etc/lighttpd/lighttpd.conf', $target_helm_repos_base_dir, $source_helm_repos_base_dir]],
      command   => 'systemctl restart lighttpd.service',
      logoutput => true,
    }

    -> Class['::platform::helm::repositories']
  }
}

class platform::helm::runtime {
  include ::platform::helm::repositories
  include ::openstack::lighttpd::runtime

  Exec['sm-restart-lighttpd'] -> Class['::platform::helm::repositories']
}

class platform::helm::v2::db::postgresql (
  $password,
  $dbname = 'helmv2',
  $user   = 'helmv2',
  $encoding   = undef,
  $privileges = 'ALL',
) {
    ::postgresql::server::db { $dbname:
      user     => $user,
      password => postgresql_password($user, $password),
      encoding => $encoding,
      grant    => $privileges,
    }
}

class platform::helm::bootstrap {
  include ::platform::helm::v2::db::postgresql
}
