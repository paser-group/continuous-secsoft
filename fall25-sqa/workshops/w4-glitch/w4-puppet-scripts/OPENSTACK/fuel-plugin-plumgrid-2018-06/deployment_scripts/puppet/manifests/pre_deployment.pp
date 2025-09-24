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

notice('MODULAR: plumgrid/pre_deployment.pp')

package { 'libvirt0' :
  ensure => '1.2.2-0ubuntu13.1.16',
} ->
package { 'libvirt-bin' :
  ensure => '1.2.2-0ubuntu13.1.16',
}
package { 'networking-plumgrid':
  ensure   => 'absent',
}

# MOS8 was tagged with the older version of puppet neutron which contains outdated PLUMgrid plugin name 

file_line { 'Replace outdated plugin package name in puppet neutron':
   path     => '/etc/puppet/modules/neutron/manifests/params.pp',
   line     => "    \$plumgrid_plugin_package    = \'networking-plumgrid\'",
   match    => "plumgrid_plugin_package",
   multiple => true
}
