#    Copyright 2016 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

notify {'MODULAR: fuel-plugin-manila/db': }

$mysql        = hiera_hash('mysql', {})
$manila       = hiera_hash('manila', {})

$db_host      = hiera('database_vip')
$db_root_user = pick($mysql['root_user'], 'root')
$db_root_password = $mysql['root_password']

$db_user      = 'manila'
$db_password  = $manila['db_password']
$db_name      = 'manila'
$allowed_hosts = [ 'localhost', '127.0.0.1', '%' ]

class { '::openstack::galera::client':
  custom_setup_class => hiera('mysql_custom_setup_class', 'galera'),
}

class { '::osnailyfacter::mysql_access':
      db_host     => $db_host,
      db_user     => $db_root_user,
      db_password => $db_root_password,
}

class { '::manila::db::mysql':
  user          => $db_user,
  password      => $db_password,
  dbname        => $db_name,
  allowed_hosts => $allowed_hosts,
}

class mysql::config {}
include mysql::config
class mysql::server {}
include mysql::server

Class['::openstack::galera::client'] ->
  Class['::osnailyfacter::mysql_access']
    -> Class['::manila::db::mysql']
