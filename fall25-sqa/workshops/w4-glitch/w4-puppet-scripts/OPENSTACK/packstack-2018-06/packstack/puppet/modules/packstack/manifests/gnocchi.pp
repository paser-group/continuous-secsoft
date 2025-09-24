class packstack::gnocchi ()
{
    create_resources(packstack::firewall, hiera('FIREWALL_GNOCCHI_RULES', {}))

    $gnocchi_cfg_db_pw = hiera('CONFIG_GNOCCHI_DB_PW')
    $gnocchi_cfg_mariadb_host = hiera('CONFIG_MARIADB_HOST_URL')

    class { '::gnocchi::wsgi::apache':
      workers => hiera('CONFIG_SERVICE_WORKERS'),
      threads => hiera('CONFIG_SERVICE_WORKERS'),
      ssl     => false
    }

    class { '::gnocchi':
      database_connection => "mysql+pymysql://gnocchi:${gnocchi_cfg_db_pw}@${gnocchi_cfg_mariadb_host}/gnocchi?charset=utf8",
    }

    class { '::gnocchi::keystone::authtoken':
      auth_uri     => hiera('CONFIG_KEYSTONE_PUBLIC_URL'),
      auth_url     => hiera('CONFIG_KEYSTONE_ADMIN_URL'),
      auth_version => hiera('CONFIG_KEYSTONE_API_VERSION'),
      password     => hiera('CONFIG_GNOCCHI_KS_PW')
    }

    class { '::gnocchi::api':
      service_name => 'httpd',
      sync_db      => true,
    }

    class { '::gnocchi::storage': }
    class { '::gnocchi::storage::file': }

    class {'::gnocchi::metricd': }

    class {'::gnocchi::statsd':
      resource_id         => '5e3fcbe2-7aab-475d-b42c-a440aa42e5ad',
      archive_policy_name => 'high',
      flush_delay         => '10',
    }

    include ::gnocchi::client
}
