class { '::aodh': }
class { '::aodh::keystone::authtoken':
  password => 'a_big_secret',
}
class { '::aodh::api':
  enabled      => true,
  service_name => 'httpd',
}
include ::apache
class { '::aodh::wsgi::apache':
  ssl => false,
}
class { '::aodh::auth':
  auth_password => 'a_big_secret',
}
class { '::aodh::evaluator': }
class { '::aodh::notifier': }
class { '::aodh::listener': }
class { '::aodh::client': }
