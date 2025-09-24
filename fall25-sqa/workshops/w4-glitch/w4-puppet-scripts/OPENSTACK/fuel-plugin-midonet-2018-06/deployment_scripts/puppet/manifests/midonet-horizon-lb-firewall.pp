#    Copyright 2016 Midokura, SARL.
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
notice('MODULAR: midonet-horizon-lb-firewall.pp')
include ::stdlib

service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
}

file_line { 'firewall enable horizon':
  path  => '/etc/openstack-dashboard/local_settings.py',
  line  => "    'enable_firewall': True,",
  match => '^\ \ \ \ \'enable_firewall.*$',
} ->

file_line { 'lb enable horizon':
  path   => '/etc/openstack-dashboard/local_settings.py',
  line   => "    'enable_lb': True,",
  match  => '^\ \ \ \ \'enable_lb.*$',
  notify => Service['apache2']
}
