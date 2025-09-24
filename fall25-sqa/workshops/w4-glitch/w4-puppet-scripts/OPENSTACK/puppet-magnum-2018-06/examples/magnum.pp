# Example: enabling magnum module in Puppet

  rabbitmq_user { 'magnum':
    admin    => true,
    password => 'an_even_bigger_secret',
    provider => 'rabbitmqctl',
    require  => Class['::rabbitmq'],
  }

  rabbitmq_user_permissions { 'magnum@/':
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['::rabbitmq'],
  }

  class { '::magnum::db::mysql':
    password => 'magnum',
  }

  class { '::magnum::db':
    database_connection => 'mysql://magnum:magnum@127.0.0.1/magnum',
  }

  class { '::magnum::keystone::domain':
    domain_password => 'oh_my_no_secret',
  }

  class { '::magnum::keystone::authtoken':
    password => 'a_big_secret',
  }

  class { '::magnum::api':
    host => '127.0.0.1',
  }

  class { '::magnum::keystone::auth':
    password     => 'a_big_secret',
    public_url   => 'http://127.0.0.1:9511/v1',
    internal_url => 'http://127.0.0.1:9511/v1',
    admin_url    => 'http://127.0.0.1:9511/v1',
  }

  class { '::magnum':
    rabbit_host         => '127.0.0.1',
    rabbit_port         => '5672',
    rabbit_userid       => 'magnum',
    rabbit_password     => 'an_even_bigger_secret',
    rabbit_use_ssl      =>  false,
    notification_driver => 'messagingv2',
  }

  class { '::magnum::conductor':
  }

  class { '::magnum::client':
  }

  class { '::magnum::certificates':
    cert_manager_type => 'local'
  }

