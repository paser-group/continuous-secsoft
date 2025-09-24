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

notify {'MODULAR: fuel-plugin-manila/ui': }

include ::apache::params
include ::apache::service

$adm_shares  = '/usr/lib/python2.7/dist-packages/manila_ui/enabled'
$hor_enabled = '/usr/share/openstack-dashboard/openstack_dashboard/enabled/'

exec {'add_share_panel':
  command => "cp ${adm_shares}/_90*.py ${hor_enabled}",
  path    => '/bin:/usr/bin',
}

Exec['add_share_panel'] ~> Service['httpd']
