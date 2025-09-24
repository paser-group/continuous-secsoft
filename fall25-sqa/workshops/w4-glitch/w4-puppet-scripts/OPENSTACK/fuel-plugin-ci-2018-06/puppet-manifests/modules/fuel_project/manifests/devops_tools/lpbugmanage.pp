#Class fuel_project::devops_tools::lpbugmanage
#
class fuel_project::devops_tools::lpbugmanage (
  $id = '',
  $consumer_key = '',
  $consumer_secret = '',
  $access_token = '',
  $access_secret = '',
  $section = 'bugmanage',
  $appname = 'lpbugmanage',
  $credfile = '/etc/lpbugmanage/credentials.conf',
  $cachedir = '/var/cache/launchpadlib/',
  $logfile = 'lpbugmanage.log',
  $env = 'staging',
  $status = 'New, Confirmed, Triaged, In Progress, Incomplete',
  $series = 'https://api.staging.launchpad.net/1.0/fuel',
  $milestone = 'https://api.staging.launchpad.net/1.0/fuel/+milestone',
  $distr = 'fuel',
  $package_name = 'python-lpbugmanage',
) {

  ensure_packages([$package_name])

  file { '/etc/lpbugmanage/credentials.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => template('fuel_project/devops_tools/credentials.erb'),
    require => Package['python-lpbugmanage'],
  }

  file { '/etc/lpbugmanage/lpbugmanage.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fuel_project/devops_tools/lpbugmanage.erb'),
    require => Package['python-lpbugmanage'],
  }

  cron { 'lpbugmanage':
    user    => 'root',
    hour    => '*/1',
    command => '/usr/bin/flock -n -x /var/lock/lpbugmanage.lock /usr/bin/lpbugmanage.py test 2>&1 | logger -t lpbugmanage',
    require => [
      Package['python-lpbugmanage'],
      File['/etc/lpbugmanage/credentials.conf'],
      File['/etc/lpbugmanage/lpbugmanage.conf'],
    ],
  }
}
