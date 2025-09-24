# Class: ssh::params
#
class ssh::params {
  $apply_firewall_rules   = false
  $bind_policy            = 'soft'
  $firewall_allow_sources = {}
  $pam_password           = 'md5'

  $packages = [
    'openssh-server'
  ]


  case $::osfamily {
    'RedHat': {
      $service = 'sshd'
    }
    'Debian': {
      $service = 'ssh'
    }
    default: {
      fatal("Unknown osfamily: ${::osfamily}. Probaly your OS is unsupported.")
    }
  }

  $sshd_config = '/etc/ssh/sshd_config'
}
