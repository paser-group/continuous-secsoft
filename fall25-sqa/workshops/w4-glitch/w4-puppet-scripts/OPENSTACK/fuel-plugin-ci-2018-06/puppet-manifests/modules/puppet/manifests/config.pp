# Class: puppet::config
#
define puppet::config (
  $archive_file_server   = undef,
  $archive_files         = undef,
  $classfile             = undef,
  $config                = undef,
  $config_template       = undef,
  $environment           = undef,
  $factpath              = undef,
  $graph                 = undef,
  $hiera_backends        = undef,
  $hiera_config          = undef,
  $hiera_config_template = undef,
  $hiera_hierarchy       = undef,
  $hiera_json_datadir    = undef,
  $hiera_logger          = undef,
  $hiera_merge_behavior  = undef,
  $hiera_yaml_datadir    = undef,
  $localconfig           = undef,
  $logdir                = undef,
  $modulepath            = undef,
  $package               = undef,
  $parser                = undef,
  $pluginsync            = undef,
  $report                = undef,
  $rundir                = undef,
  $server                = undef,
  $service               = undef,
  $ssldir                = undef,
  $vardir                = undef,
) {
  if (!defined(File["${config}.d"])) {
    file { "${config}.d" :
      ensure => 'directory',
    }
  }

  file { "${config}.d/${title}.conf" :
    ensure  => 'present',
    mode    => '0644',
    owner   => 'puppet',
    group   => 'puppet',
    content => template($config_template),
    notify  => Exec['puppet.conf-merge-pieces'],
  }

  if (!defined(Exec['puppet.conf-merge-pieces'])) {
    exec { 'puppet.conf-merge-pieces' :
      command => "cat ${config}.d/* > ${config}",
      require => File["${config}.d/${title}.conf"],
    }
  }
}
