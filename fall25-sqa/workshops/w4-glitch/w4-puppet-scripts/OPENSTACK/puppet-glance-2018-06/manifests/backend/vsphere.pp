#
# Copyright (C) 2014 Mirantis
#
# Author: Stepan Rogov <srogov@mirantis.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: glance::backend::vsphere
#
# Setup Glance to backend images into VMWare vCenter/ESXi
#
# === Parameters
#
# [*vcenter_insecure*]
#   (optional) If true, the ESX/vCenter server certificate is not verified.
#   If false, then the default CA truststore is used for verification.
#   This option is ignored if "vcenter_ca_file" is set.
#   Defaults to 'True'.
#
# [*vcenter_ca_file*]
#   (optional) The name of the CA bundle file which will be used in
#   verifying vCenter server certificate. If parameter is not set
#   then system truststore is used. If parameter is set,
#   vcenter_insecure value is ignored.
#   Defaults to $::os_service_default.
#
# [*vcenter_datastores*]
#   (Multi-valued) A list of datastores where the image
#   can be stored. This option may be specified multiple times
#   for specifying multiple datastores. The datastore name should
#   be specified after its datacenter path, separated by ":".
#   An optional weight may be given after the datastore name,
#   separated again by ":". Thus, the required format
#   becomes <datacenter_path>:<datastore_name>:<optional_weight>.
#   When adding an image, the datastore with highest weight will be selected,
#   unless there is not enough free space available in cases where the image
#   size is already known. If no weight is given, it is assumed to be
#   zero and the directory will be considered for selection last.
#   If multiple datastores have the same weight, then the one with the most
#   free space available is selected.
#   Defaults to $::os_service_default.
#
# [*vcenter_host*]
#   (required) vCenter/ESXi Server target system.
#   Should be a valid an IP address or a DNS name.
#
# [*vcenter_user*]
#   (required) Username for authenticating with vCenter/ESXi server.
#
# [*vcenter_password*]
#   (required) Password for authenticating with vCenter/ESXi server.
#
# [*vcenter_image_dir*]
#   (required) The name of the directory where the glance images will be stored
#   in the VMware datastore.
#
# [*vcenter_task_poll_interval*]
#   (optional) The interval used for polling remote tasks invoked on
#   vCenter/ESXi server.
#   Defaults to $::os_service_default.
#
# [*vcenter_api_retry_count*]
#   (optional) Number of times VMware ESX/VC server API must be retried upon
#   connection related issues.
#   Defaults to $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false.
#
class glance::backend::vsphere(
  $vcenter_host,
  $vcenter_user,
  $vcenter_password,
  $vcenter_image_dir,
  $vcenter_ca_file            = $::os_service_default,
  $vcenter_datastores         = $::os_service_default,
  $vcenter_insecure           = 'True',
  $vcenter_task_poll_interval = $::os_service_default,
  $vcenter_api_retry_count    = $::os_service_default,
  $multi_store                = false,
) {

  include ::glance::deps

  glance_api_config {
    'glance_store/vmware_insecure': value           => $vcenter_insecure;
    'glance_store/vmware_ca_file': value            => $vcenter_ca_file;
    'glance_store/vmware_server_host': value        => $vcenter_host;
    'glance_store/vmware_server_username': value    => $vcenter_user;
    'glance_store/vmware_server_password': value    => $vcenter_password, secret => true;
    'glance_store/vmware_store_image_dir': value    => $vcenter_image_dir;
    'glance_store/vmware_task_poll_interval': value => $vcenter_task_poll_interval;
    'glance_store/vmware_api_retry_count': value    => $vcenter_api_retry_count;
    'glance_store/vmware_datastores': value         => $vcenter_datastores;
  }

  if !$multi_store {
    glance_api_config {  'glance_store/default_store': value => 'vsphere'; }
  }
}
