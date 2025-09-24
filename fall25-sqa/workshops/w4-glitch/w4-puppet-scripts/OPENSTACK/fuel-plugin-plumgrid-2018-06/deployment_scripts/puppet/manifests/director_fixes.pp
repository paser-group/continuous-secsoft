#
# Copyright (c) 2016, PLUMgrid Inc, http://plumgrid.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

notice('MODULAR: plumgrid/director_fixes.pp')

file { '/etc/apache2/ports.conf':
  ensure => present,
}

file_line { 'ensure no port conflict between apache and keystone':
  path    => '/etc/apache2/ports.conf',
  line    => 'NameVirtualHost *:35357',
  ensure  => 'absent',
  require => File['/etc/apache2/ports.conf']
}

file_line { 'ensure no port conflict between apache-keystone':
  path    => '/etc/apache2/ports.conf',
  line    => 'NameVirtualHost *:5000',
  ensure  => 'absent',
  require => File['/etc/apache2/ports.conf']
}

ini_setting { 'Add Project domain name variable to plumlib.ini':
  ensure  => 'present',
  path    => '/etc/neutron/plugins/plumgrid/plumlib.ini',
  section => 'keystone_authtoken',
  setting => 'user_domain_name',
  value   => 'Default',
}

ini_setting { 'Add enable_reverse_flow paramater in plumlib.ini':
  ensure  => 'present',
  path    => '/etc/neutron/plugins/plumgrid/plumlib.ini',
  section => 'PLUMgridLibrary',
  setting => 'enable_reverse_flow_tap',
  value   => 'True',
}

ini_setting { 'Add nova_metaconfig paramater in plumlib.ini':
  ensure  => 'present',
  path    => '/etc/neutron/plugins/plumgrid/plumlib.ini',
  section => 'PLUMgridLibrary',
  setting => 'nova_metaconfig',
  value   => 'True',
}
