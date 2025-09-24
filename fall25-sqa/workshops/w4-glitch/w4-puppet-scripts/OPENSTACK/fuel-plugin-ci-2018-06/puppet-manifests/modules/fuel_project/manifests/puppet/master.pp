# Class: fuel_project::puppet::master
#
class fuel_project::puppet::master (
  $apply_firewall_rules    = false,
  $enable_update_cronjob   = true,
  $external_host           = false,
  $firewall_allow_sources  = {},
  $hiera_backends          = ['yaml'],
  $hiera_config            = '/etc/hiera.yaml',
  $hiera_config_template   = 'puppet/hiera.yaml.erb',
  $hiera_hierarchy         = ['nodes/%{::clientcert}', 'roles/%{::role}', 'locations/%{::location}', 'common'],
  $hiera_json_datadir      = '/var/lib/hiera',
  $hiera_logger            = 'console',
  $hiera_merge_behavior    = 'deeper',
  $hiera_yaml_datadir      = '/var/lib/hiera',
  $manifests_binpath       = '/etc/puppet/bin',
  $manifests_branch        = 'master',
  $manifests_manifestspath = '/etc/puppet/manifests',
  $manifests_modulespath   = '/etc/puppet/modules',
  $manifests_repo          = 'ssh://puppet-master-tst@review.fuel-infra.org:29418/fuel-infra/puppet-manifests',
  $manifests_tmpdir        = '/tmp/puppet-manifests',
  $puppet_config           = '/etc/puppet/puppet.conf',
  $puppet_environment      = 'production',
  $puppet_master_run_with  = 'nginx+uwsgi',
  $puppet_server           = $::fqdn,
) {
  class { '::fuel_project::common' :
    external_host => $external_host,
  }
  class { '::fuel_project::nginx' :
    require => Class['::fuel_project::common'],
  }
  class { '::puppet::master' :
    apply_firewall_rules   => $apply_firewall_rules,
    firewall_allow_sources => $firewall_allow_sources,
    hiera_backends         => $hiera_backends,
    hiera_config           => $hiera_config,
    hiera_config_template  => $hiera_config_template,
    hiera_hierarchy        => $hiera_hierarchy,
    hiera_json_datadir     => $hiera_json_datadir,
    hiera_logger           => $hiera_logger,
    hiera_merge_behavior   => $hiera_merge_behavior,
    hiera_yaml_datadir     => $hiera_yaml_datadir,
    config                 => $puppet_config,
    environment            => $puppet_environment,
    server                 => $puppet_server,
    puppet_master_run_with => $puppet_master_run_with,
    require                => [
      Class['::fuel_project::common'],
      Class['::fuel_project::nginx'],
    ],
  }
  file { '/usr/local/bin/puppet-manifests-update.sh' :
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('fuel_project/puppet/master/puppet-manifests-update.sh.erb')
  }
  if ($enable_update_cronjob) {
    cron { 'puppet-manifests-update' :
      command => '/usr/bin/timeout -k80 60 /usr/local/bin/puppet-manifests-update.sh 2>&1 | logger -t puppet-manifests-update',
      user    => 'root',
      minute  => '*/5',
      require => File['/usr/local/bin/puppet-manifests-update.sh'],
    }
  }
}
