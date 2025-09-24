notice('MURANO PLUGIN: murano_dashboard.pp')

$murano_hash    = hiera_hash('murano_plugin', {})
$murano_plugins = $murano_hash['plugins']
$app_catalog_ui = hiera('app_catalog_ui', false)
$repository_url = has_key($murano_hash, 'murano_repo_url') ? {
  true    => $murano_hash['murano_repo_url'],
  default => 'http://storage.apps.openstack.org',
}
if has_key($murano_plugins, 'glance_artifacts_plugin') and $murano_plugins['glance_artifacts_plugin']['enabled'] {
  $use_glare = true
  package {'murano-glance-artifacts-plugin':
    ensure  => 'latest',
  }

  include ::glance::params
  ensure_resource('service', 'glance-glare',
    { ensure => running, name => $::glance::params::glare_service_name })
  Package['murano-glance-artifacts-plugin'] ~> Service['glance-glare']
} else {
  $use_glare = false
}

if $app_catalog_ui {
  package {'python-app-catalog-ui':
    ensure  => 'latest',
  }
}

include ::murano::params
include ::horizon::params

ensure_resource('service', 'httpd', {
  'ensure'  => 'running',
  'name'    => $::horizon::params::http_service,
})

class { '::murano::client':
  package_ensure => 'latest'
}

class { '::murano::dashboard':
  enable_glare   => $use_glare,
  repo_url       => $repository_url,
  sync_db        => false,
  package_ensure => 'latest'
}

Concat<||> ~> Service['httpd']
