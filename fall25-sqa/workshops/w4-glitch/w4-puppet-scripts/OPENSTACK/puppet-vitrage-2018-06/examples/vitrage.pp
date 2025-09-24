class { '::vitrage::keystone::auth':
  admin_url    => 'http://127.0.0.1:8999',
  internal_url => 'http://127.0.0.1:8999',
  public_url   => 'http://127.0.0.1:8999',
  password     => 'a_big_secret',
}
class { '::vitrage': }
class { '::vitrage::api':
  enabled               => true,
  keystone_password     => 'a_big_secret',
  keystone_identity_uri => 'http://127.0.0.1:35357/',
  service_name          => 'httpd',
}
include ::apache
class { '::vitrage::wsgi::apache':
  ssl => false,
}
class { '::vitrage::auth':
  auth_password => 'a_big_secret',
}
class { '::vitrage::graph': }
class { '::vitrage::notifier': }
class { '::vitrage::client': }
