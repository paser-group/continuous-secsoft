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
notice('MODULAR: midonet-host-registry.pp')

# Extract data from hiera
$api_ip      = hiera('management_vip')
$access_data = hiera_hash('access')
$username    = $access_data['user']
$password    = $access_data['password']
$tenant_name = $access_data['tenant']

# Plugin settings data
$midonet_settings = hiera_hash('midonet')
$tz_type = $midonet_settings['tunnel_type']

$service_path = $operatingsystem ? {
  'CentOS' => '/sbin',
  'Ubuntu' => '/usr/bin:/usr/sbin:/sbin'
}

# Somehow, there are times where the hosts don't register
# to NSDB. Restarting midolman forces the registration
exec {'service midolman restart':
  path   => $service_path
} ->

midonet_host_registry {$::fqdn:
  ensure              => present,
  midonet_api_url     => "http://${api_ip}:8181",
  username            => $username,
  password            => $password,
  tenant_name         => $tenant_name,
  underlay_ip_address => $::ipaddress_br_mesh,
  tunnelzone_type     => $tz_type,
  tunnelzone_name     => 'tzonefuel'
}
