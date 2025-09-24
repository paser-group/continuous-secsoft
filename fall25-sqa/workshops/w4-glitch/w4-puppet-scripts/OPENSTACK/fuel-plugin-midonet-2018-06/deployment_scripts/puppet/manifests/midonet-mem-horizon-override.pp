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
notice('MODULAR: midonet-mem-horizon-override.pp')
include ::stdlib

service { 'apache2':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
}

file_line { 'vhost horizon start':
  ensure            => absent,
  path              => '/etc/apache2/sites-enabled/horizon_vhost.conf',
  line              => '# disabled by puppet',
  match             => '^\<VirtualHost.*',
  match_for_absence => true,
  replace           => false
} ->

file_line { 'dont aggresively redirect horizon':
  ensure            => absent,
  path              => '/etc/apache2/sites-enabled/horizon_vhost.conf',
  line              => '# disabled by puppet',
  match             => '^\ \ RedirectMatch.*',
  match_for_absence => true,
  replace           => false
} ->

file_line { 'dont set servername again for horizon':
  ensure            => absent,
  path              => '/etc/apache2/sites-enabled/horizon_vhost.conf',
  line              => '# disabled by puppet',
  match             => '^\ \ ServerName.*',
  match_for_absence => true,
  replace           => false
} ->

file_line { 'dont set serveralias again for horizon':
  ensure            => absent,
  path              => '/etc/apache2/sites-enabled/horizon_vhost.conf',
  line              => '# disabled by puppet',
  match             => '^\ \ ServerAlias.*',
  match_for_absence => true,
  replace           => false
} ->

file_line { 'remove closing horizon vhost':
  ensure            => absent,
  path              => '/etc/apache2/sites-enabled/horizon_vhost.conf',
  line              => '# disabled by puppet',
  match             => '^\<\/VirtualHost.*',
  match_for_absence => true,
  replace           => false,
  notify            => Service['apache2']
} ->

file { '/var/www/html/index.html':
  ensure => absent
  }
