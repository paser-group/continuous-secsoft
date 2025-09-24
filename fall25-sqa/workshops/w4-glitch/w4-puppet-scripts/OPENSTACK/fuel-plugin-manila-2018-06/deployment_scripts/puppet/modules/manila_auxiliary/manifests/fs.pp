class manila_auxiliary::fs () {

  user {'manila':
    ensure => 'present',
    home   => '/var/lib/manila',
    shell  => '/bin/bash',
    system => true,
  }->
  file {'/etc/manila':
    ensure => 'directory',
    owner  => 'manila',
    group  => 'manila',
  }->
  file {'/etc/manila/rootwrap.d':
    ensure => 'directory',
    owner  => 'manila',
    group  => 'manila',
  }
  file {'/var/log/manila':
    ensure => 'directory',
    owner  => 'manila',
    group  => 'manila',
  }
  file {'/var/lib/manila':
    ensure => 'directory',
    owner  => 'manila',
    group  => 'manila',
  }->
  file {'/var/lib/manila/tmp':
    ensure => 'directory',
    owner  => 'manila',
    group  => 'manila',
  }
  file {'/etc/manila/api-paste.ini':
    source => 'puppet:///modules/manila_auxiliary/api-paste.ini',
    owner  => 'manila',
    group  => 'manila',
  }
  file {'/etc/manila/logging_sample.conf':
    source => 'puppet:///modules/manila_auxiliary/logging_sample.conf',
    owner  => 'manila',
    group  => 'manila',
  }
  file {'/etc/manila/policy.json':
    source => 'puppet:///modules/manila_auxiliary/policy.json',
    owner  => 'manila',
    group  => 'manila',
  }
  file {'/etc/manila/rootwrap.conf':
    source => 'puppet:///modules/manila_auxiliary/rootwrap.conf',
    owner  => 'root',
    group  => 'root',
  }
  file {'/etc/manila/rootwrap.d/share.filters':
    source => 'puppet:///modules/manila_auxiliary/share.filters',
    owner  => 'root',
    group  => 'root',
  }
  file {'/etc/sudoers.d/manila-common':
    source => 'puppet:///modules/manila_auxiliary/manila-common',
    owner  => 'root',
    group  => 'root',
  }
}
