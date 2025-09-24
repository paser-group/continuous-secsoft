# Class: puppet::agent
#
class puppet::agent (
  $archive_file_server = $::puppet::params::archive_file_server,
  $archive_files       = $::puppet::params::archive_files,
  $classfile           = $::puppet::params::classfile,
  $config              = $::puppet::params::config,
  $config_template     = $::puppet::params::agent_config_template,
  $environment         = $::puppet::params::environment,
  $factpath            = $::puppet::params::factpath,
  $graph               = $::puppet::params::graph,
  $localconfig         = $::puppet::params::localconfig,
  $logdir              = $::puppet::params::logdir,
  $modulepath          = $::puppet::params::modulepath,
  $package             = $::puppet::params::agent_package,
  $parser              = $::puppet::params::parser,
  $pluginsync          = $::puppet::params::pluginsync,
  $report              = $::puppet::params::report,
  $rundir              = $::puppet::params::rundir,
  $server              = $::puppet::params::server_fqdn,
  $service             = $::puppet::params::agent_service,
  $ssldir              = $::puppet::params::ssldir,
  $vardir              = $::puppet::params::vardir,
) inherits ::puppet::params {
  puppet::config { 'agent-config' :
    archive_file_server => $archive_file_server,
    archive_files       => $archive_files,
    classfile           => $classfile,
    config              => $config,
    config_template     => $config_template,
    environment         => $environment,
    factpath            => $factpath,
    graph               => $graph,
    localconfig         => $localconfig,
    logdir              => $logdir,
    modulepath          => $modulepath,
    parser              => $parser,
    pluginsync          => $pluginsync,
    report              => $report,
    rundir              => $rundir,
    server              => $server,
    ssldir              => $ssldir,
    vardir              => $vardir,
  }

  ensure_packages([$package])

  service { $service :
    ensure  => 'stopped',
    enable  => false,
    require => Package[$package]
  }
}
