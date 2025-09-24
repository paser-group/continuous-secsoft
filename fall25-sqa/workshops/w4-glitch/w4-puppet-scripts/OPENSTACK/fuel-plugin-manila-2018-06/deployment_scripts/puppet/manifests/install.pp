notify {'MODULAR: fuel-plugin-manila/install': }

package {'python-pip':
  ensure => 'installed'
}

package {'python-pymysql':
  ensure => 'installed'
}
package {'python-dev':
  ensure => 'installed'
}

package {'pycrypto':
  ensure   => 'installed',
  provider => 'pip',
}

package {'python-manilaclient':
  ensure   => '1.11.0',
  provider => 'pip',
}

package {'python-manila':
  ensure => 'absent'
}

package {'manila-api':
  ensure => 'absent'
}

package {'manila-common':
  ensure => 'absent'
}

package {'manila-scheduler':
  ensure => 'absent'
}

package {'fuel-plugin-manila-manila-core':
  ensure => 'installed'
}

package {'fuel-plugin-manila-manila-ui':
  ensure => 'installed'
}

class {'::manila_auxiliary::fs': }

Package['python-pip']->
Package['python-dev']->
Package['python-pymysql']->
Package['pycrypto']->
Package['python-manilaclient']->
Package['python-manila']->
Package['manila-api']->
Package['manila-common']->
Package['manila-scheduler']->
Package['fuel-plugin-manila-manila-core']->
Package['fuel-plugin-manila-manila-ui']
