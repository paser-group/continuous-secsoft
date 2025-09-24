# Define: puppet::facter
#
define puppet::facter (
  $facts,
) {
  ensure_packages(['bash'])

  file { '/etc/facter' :
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/facter/facts.d' :
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/facter'],
  }

  file { "/etc/facter/facts.d/${title}.sh" :
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('puppet/facts.sh.erb'),
    require => File['/etc/facter/facts.d'],
  }
}
