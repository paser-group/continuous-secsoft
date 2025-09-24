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
notice('MODULAR: midonet-generate-openrc-for-gw.pp')

$access_hash        = hiera_hash('access', {})
$keystone_hash      = hiera_hash('keystone', {})
$admin_tenant       = $access_hash['tenant']
$admin_email        = $access_hash['email']
$admin_user         = $access_hash['user']
$admin_password     = $access_hash['password']
$ssl_hash           = hiera_hash('use_ssl', {})
$management_vip     = hiera('management_vip')
$service_endpoint   = hiera('service_endpoint', $management_vip)
$internal_protocol  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
$internal_address   = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [$service_endpoint, $management_vip])
$internal_port      = '5000'
$internal_url       = "${internal_protocol}://${internal_address}:${internal_port}"
$region             = hiera('region', 'RegionOne')
$auth_suffix        = pick($keystone_hash['auth_suffix'], '/')
$auth_url           = "${internal_url}${auth_suffix}"


$murano_settings_hash = hiera_hash('murano_settings', {})
if has_key($murano_settings_hash, 'murano_repo_url') {
  $murano_repo_url = $murano_settings_hash['murano_repo_url']
} else {
  $murano_repo_url = 'http://storage.apps.openstack.org'
}

$murano_hash    = hiera_hash('murano', {})
$murano_plugins = pick($murano_hash['plugins'], {})
if has_key($murano_plugins, 'glance_artifacts_plugin') {
  $murano_glare_plugin = $murano_plugins['glance_artifacts_plugin']['enabled']
} else {
  $murano_glare_plugin = false
}

osnailyfacter::credentials_file { '/root/openrc':
  admin_user          => $admin_user,
  admin_password      => $admin_password,
  admin_tenant        => $admin_tenant,
  region_name         => $region,
  auth_url            => $auth_url,
  murano_repo_url     => $murano_repo_url,
  murano_glare_plugin => $murano_glare_plugin,
}
