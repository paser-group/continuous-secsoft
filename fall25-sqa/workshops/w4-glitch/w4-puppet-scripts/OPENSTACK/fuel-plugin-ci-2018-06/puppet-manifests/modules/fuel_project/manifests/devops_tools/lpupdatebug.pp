# Class fuel_project::devops_tools::lpupdatebug
#
class fuel_project::devops_tools::lpupdatebug (
  $access_token = '',
  $access_secret = '',
  $appname = 'lpupdatebug',
  $cachedir = '/var/tmp/launchpadlib/',
  $consumer_key = '',
  $consumer_secret = '',
  $credfile = '/etc/lpupdatebug/credentials.conf',
  $env = 'production',
  $host = 'localhost',
  $id = '1',
  $logfile = '/var/log/lpupdatebug.log',
  $package_name = 'python-lpupdatebug',
  $port = '29418',
  $projects = [],
  $sshprivkey = '/etc/lpupdatebug/lpupdatebug.key',
  $sshprivkey_contents = undef,
  $update_status = 'yes',
  $username = 'lpupdatebug',
) {

  ensure_packages([$package_name])

  if ($sshprivkey_contents)
  {
    file { $sshprivkey :
      owner   => 'root',
      group   => 'root',
      mode    => '0400',
      content => $sshprivkey_contents,
    }
  }

  file { '/etc/lpupdatebug/credentials.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template('fuel_project/devops_tools/credentials.erb'),
    require => Package['python-lpupdatebug'],
  }

  file { '/etc/lpupdatebug/lpupdatebug.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fuel_project/devops_tools/lpupdatebug.erb'),
    require => Package['python-lpupdatebug'],
  }

  service { 'python-lpupdatebug' :
    ensure     => running,
    enable     => true,
    hasrestart => false,
    require    => Package[$package_name]
  }

  ensure_packages(['tailnew'])

  zabbix::item { 'lpupdatebug-zabbix-check' :
    content => 'puppet:///modules/fuel_project/devops_tools/userparams-lpupdatebug.conf',
    notify  => Service[$::zabbix::params::agent_service],
    require => Package['tailnew']
  }
}
