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

notify {'MODULAR: fuel-plugin-manila/db-sync': }

$manila  = hiera_hash('manila', {})
$db_pass = $manila['db_password']
$db_host = hiera('database_vip')
$req     = 'select name from availability_zones\G'

exec { 'manual_db_sync':
  command => 'manila-manage db sync',
  path    => '/usr/bin:/bin',
  user    => 'manila',
  unless  => "mysql -u manila -p${db_pass} -h ${db_host} -e \"${req}\" manila | grep nova"
}
