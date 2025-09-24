if $::osfamily == 'Debian' {

  package { 'nova-network':
    ensure => installed
  }

}

