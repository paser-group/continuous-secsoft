# Class: fuel_project::roles::ns
#
class fuel_project::roles::ns (
  $dns_repo,
  $dns_branch                       = 'master',
  $dns_checkout_private_key_content = undef,
  $dns_tmpdir                       = '/tmp/ns-update',
  $firewall_enable                  = false,
  $firewall_rules                   = {},
  $role                             = 'master',
  $target_path                      = '/var/cache/bind',
) {
  class { '::fuel_project::common' :
    external_host => $firewall_enable,
  }
  class { '::bind' :}
  ::bind::server::conf { '/etc/bind/named.conf' :
    require => Class['::bind'],
  }

  if ($role == 'master') {
    ensure_packages(['git'])

    file { '/usr/local/bin/ns-update.sh' :
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('fuel_project/roles/ns/ns-update.sh.erb'),
      require => [
        Class['::bind'],
        ::Bind::Server::Conf['/etc/bind/named.conf'],
        Package['git'],
      ],
    }

    cron { 'ns-update' :
      command => '/usr/bin/timeout -k80 60 /usr/local/bin/ns-update.sh 2>&1 | logger -t ns-update',
      user    => 'root',
      minute  => '*/5',
      require => File['/usr/local/bin/ns-update.sh'],
    }
  }

  ensure_packages(['perl', 'perl-base'])

  file { '/usr/local/bin/bind96-stats-parse.pl' :
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/fuel_project/ns/bind96-stats-parse.pl',
    require => [
      Package['perl'],
      Package['perl-base']
    ],
  }

  file { '/var/lib/bind/statistics.txt' :
    ensure => 'present',
    owner  => 'bind',
    group  => 'bind',
  }

  cron { 'rndc-stats' :
    command => '>/var/lib/bind/statistics.txt ; /usr/sbin/rndc stats',
    user    => 'root',
    minute  => '*/5',
    require => [
      File['/var/lib/bind/statistics.txt'],
      File['/usr/local/bin/bind96-stats-parse.pl'],
    ],
  }

  ::zabbix::item { 'bind' :
    content => 'puppet:///modules/fuel_project/ns/zabbix_bind.conf',
  }

  if ($dns_checkout_private_key_content) {
    file { '/root/.ssh' :
      ensure => 'directory',
      mode   => '0500',
      owner  => 'root',
      group  => 'root',
    }

    file { '/root/.ssh/id_rsa' :
      ensure  => 'present',
      content => $dns_checkout_private_key_content,
      mode    => '0400',
      owner   => 'root',
      group   => 'root',
      require => File['/root/.ssh'],
    }
  }

  if ($firewall_enable) {
    include firewall_defaults::pre
    create_resources(firewall, $firewall_rules, {
      action  => 'accept',
      require => Class['firewall_defaults::pre'],
    })
  }
}
