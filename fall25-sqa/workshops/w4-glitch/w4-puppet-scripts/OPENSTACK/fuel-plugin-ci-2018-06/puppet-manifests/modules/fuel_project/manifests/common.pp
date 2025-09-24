# Class: fuel_project::common
#
class fuel_project::common (
  $bind_policy        = '',
  $external_host      = false,
  $facts              = {
    'location' => $::location,
    'role'     => $::role,
  },
  $kernel_package     = undef,
  $ldap               = false,
  $ldap_base          = '',
  $ldap_ignore_users  = '',
  $ldap_uri           = '',
  $logrotate_rules    = hiera_hash('logrotate::rules', {}),
  $pam_filter         = '',
  $pam_password       = '',
  $root_password_hash = 'pa$$w0rd',
  $root_shell         = '/bin/bash',
  $tls_cacertdir      = '',
) {
  class { '::atop' :}
  class { '::ntp' :}
  class { '::puppet::agent' :}
  class { '::ssh::authorized_keys' :}
  class { '::ssh::sshd' :
    apply_firewall_rules => $external_host,
  }
  # TODO: remove ::system module
  # ... by spliting it's functions to separate modules
  # or reusing publically available ones
  class { '::system' :}

  ::puppet::facter { 'facts' :
    facts => $facts,
  }

  ensure_packages([
    'apparmor',
    'facter-facts',
    'screen',
    'tmux',
  ])

  # install the exact version of kernel package
  # please note, that reboot must be done manually
  if($kernel_package) {
    ensure_packages($kernel_package)
  }

  
  case $::osfamily {
    'Debian': {
      class { '::apt' :}
    }
    'RedHat': {
      class { '::yum' :}
    }
    default: { }
  }

  # Logrotate items
  create_resources('::logrotate::rule', $logrotate_rules)

  mount { '/' :
    ensure  => 'present',
    options => 'defaults,errors=remount-ro,noatime,nodiratime,barrier=0',
  }

  file { '/etc/hostname' :
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "${::fqdn}\n",
    notify  => Exec['/bin/hostname -F /etc/hostname'],
  }

  file { '/etc/hosts' :
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fuel_project/common/hosts.erb'),
  }

  exec { '/bin/hostname -F /etc/hostname' :
    subscribe   => File['/etc/hostname'],
    refreshonly => true,
    require     => File['/etc/hostname'],
  }
}
