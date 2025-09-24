#
#    Copyright 2016 Pure Storage, Inc.
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
$plugin_settings = hiera('fuel-plugin-purestorage-cinder')

class { 'plugin_purestorage_cinder::controller' :
  section   => 'pure',
  glance_image_cache => $plugin_settings['pure_glance_image_cache'],
  glance_image_count => $plugin_settings["pure_glance_cache_count"],
  glance_image_size => $plugin_settings["pure_glance_cache_size"],
  replication => $plugin_settings['pure_replication'],
  remote_array => $plugin_settings["pure_replication_name"],
  remote_ip => $plugin_settings["pure_replication_ip"],
  remote_api => $plugin_settings["pure_replication_api"],
  replication_default => $plugin_settings['pure_replication_default'],
  replication_interval => $plugin_settings["pure_interval"],
  replication_short => $plugin_settings["pure_retention_short"],
  replication_long_day => $plugin_settings["pure_retention_long_day"],
  replication_long => $plugin_settings["pure_retention_long"],
  eradicate => $plugin_settings['pure_eradicate'],
  local_ip => $plugin_settings['pure_san_ip'],
  local_api => $plugin_settings['pure_api'],
  local_chap => $plugin_settings['pure_chap'],
  local_multipath => $plugin_settings['pure_multipath'],
  protocol => $plugin_settings['pure_protocol'],
  consis_group => $plugin_settings['pure_cg'],
  fczm_config => $plugin_settings['pure_fczm_config'],
  fc_vendor => $plugin_settings['pure_switch_vendor'],
  fabric_count => $plugin_settings['pure_fabric_count'],
  fabric_name_1 => $plugin_settings['pure_fabric_name_1'],
  fabric_name_2 => $plugin_settings['pure_fabric_name_2'],
  fc_ip_1 => $plugin_settings["pure_fabric_ip_1"],
  fc_ip_2 => $plugin_settings["pure_fabric_ip_2"],
  fc_user_1 => $plugin_settings["pure_username_1"],
  fc_user_2 => $plugin_settings["pure_username_2"],
  fc_passwd_1 => $plugin_settings["pure_password_1"],
  fc_passwd_2 => $plugin_settings["pure_password_2"],
  fc_prefix_1 => $plugin_settings["pure_fabric_name_1"],
  fc_prefix_2 => $plugin_settings["pure_fabric_name_2"],
  fc_vsan_1 => $plugin_settings["pure_vsan_1"],
  fc_vsan_2 => $plugin_settings["pure_vsan_2"],
}
