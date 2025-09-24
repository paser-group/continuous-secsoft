#
#    Copyright 2015 BigSwitch Networks, Inc.
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
#
notice('MODULAR: bigswitch reconfigure-keystone')

# configure /etc/keystone/keystone.conf
ini_setting { 'keystone.conf notification driver':
  ensure            => present,
  path              => '/etc/keystone/keystone.conf',
  section           => 'DEFAULT',
  key_val_separator => '=',
  setting           => 'notification_driver',
  value             => 'messaging',
  notify            => Service['keystone'],
}

service { 'keystone':
  ensure => running,
  enable => true,
}
