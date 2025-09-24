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

notify {'MODULAR: fuel-plugin-manila/start_controller': }

$inits = {
  'manila-api' => {
    desc => 'manila-api init script',
    srv  => 'manila-api',},
  'manila-scheduler' => {
    desc => 'manila-scheduler init script',
    srv  => 'manila-scheduler',},
}

create_resources('::manila_auxiliary::initd', $inits)

notify {'Restart manila-api':
  }~>
  service { 'manila-api':
    ensure    => 'running',
    name      => 'manila-api',
    enable    => true,
    hasstatus => true,
    }->
    notify {' Restart manila-scheduler':
      }~>
      service { 'manila-scheduler':
        ensure    => 'running',
        name      => 'manila-scheduler',
        enable    => true,
        hasstatus => true,
      }
