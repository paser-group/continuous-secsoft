#    Copyright 2015 Midokura SARL.
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
notice('MODULAR: midonet-replace-guess-func.pp')

# NOTE: This replacement may be only needed on Ubuntu hosts
file_line { 'replace_guess':
  path     => '/usr/share/neutron-common/plugin_guess_func',
  match    => '"neutron.plugins.midonet.plugin.MidonetPluginV2"',
  line     => "\t\"midonet.neutron.plugin_v2.MidonetPluginV2\")",
  multiple => true
}
