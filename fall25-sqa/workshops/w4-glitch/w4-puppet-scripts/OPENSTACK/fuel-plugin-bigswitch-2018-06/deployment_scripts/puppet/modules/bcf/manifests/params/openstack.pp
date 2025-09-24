#
#    Copyright 2015 BigSwitch Networks
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
class bcf::params::openstack {

  $virtual_cluster_name  = 'OpenStackCluster'
  $ceph_virtual_cluster_name  = 'CephCluster'

  $quantum_settings      = hiera('quantum_settings')
  $keystone_vip          = hiera('management_vip')
  $auth_user             = 'neutron'
  $auth_password         = $quantum_settings['keystone']['admin_password']
  $auth_tenant_name      = 'services'

  $neutron_adv_conf      = hiera('neutron_advanced_configuration')
  $neutron_dvr           = $neutron_adv_conf['neutron_dvr']
  $network_scheme        = hiera('network_scheme')
  $fuel_master           = hiera('master_ip')
  $bcf_hash              = hiera('fuel-plugin-bigswitch')

  $access_hash           = hiera('access')
  $keystone_hash         = hiera('keystone')
  $nova_hash             = hiera('nova')
  $neutron_hash          = hiera('neutron_config')
  $cinder_hash           = hiera('cinder')
  $rabbit_hash           = hiera('rabbit')

  $bcf_mode              = $bcf_hash['bcf_mode']
  $bcf_controller_1      = "${bcf_hash['bcf_controller_1']}"
  $bcf_controller_2      = "${bcf_hash['bcf_controller_2']}"
  $bcf_username          = $bcf_hash['bcf_controller_username']
  $bcf_password          = $bcf_hash['bcf_controller_password']
  $bcf_instance_id       = $bcf_hash['openstack_instance_id']
  $bcf_os_mgmt_tenant    = $bcf_hash['openstack_mgmt_tenant']
  $bcf_version           = $bcf_hash['bcf_version']
  $access_tenant         = 'services'
}
