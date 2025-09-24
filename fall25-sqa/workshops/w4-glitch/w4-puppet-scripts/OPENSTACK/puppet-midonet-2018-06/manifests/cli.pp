# == Class: midonet::midonet_cli
#
# Install midonet_cli
#
# === Parameters
#
# [*api_endpoint*]
#   Url to make the API calls to, usually it is the controller
# [*username*]
#   Keystone username
# [*password*]
#   KKeystone Password
# [*tenant_name*]
#   Tenant Name
# [*package_ensure*]
#   Type of ensure, 'present' or 'absent' ..
# [*manage_epel*]
#   Install epel repo?
#     Default: true
#
# === Examples
#
#   class midonet::midonet_cli(
#     $api_endpoint='http://127.0.0.1:8181/midonet-api',
#     $username='admin',
#     $password='admin',
#     $tenant_name='admin',
#   )
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2015 Midokura SARL, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class midonet::cli(
  $api_endpoint   = 'http://127.0.0.1:8181/midonet-api',
  $username       = 'admin',
  $password       = 'admin',
  $tenant_name    = 'admin',
  $package_ensure = 'present',
  $manage_epel    = true,
) {

  if $::osfamily == 'RedHat' {
    if $manage_epel {
      package { 'epel-release':
        ensure => installed,
        before => Package['python-midonetclient']
      }
    }
  }

  package { 'python-midonetclient': ensure  => $package_ensure, }

  midonet_client_conf {
    'cli/api_url':    value => $api_endpoint;
    'cli/username':   value => $username;
    'cli/password':   value => $password;
    'cli/project_id': value => $tenant_name;
  }

}
