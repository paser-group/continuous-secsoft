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

class plumgrid::params {
  $plumgrid_package = 'plumgrid-lxc'
  case $::osfamily {
    'RedHat', 'Linux': {
      $manage_repo = false
      $libvirt_package = 'libvirt-daemon-driver-lxc'
      $libvirt_service = 'libvirtd'
      $kernel_header_package = 'kernel-devel'
    }
    'Debian': {
      $manage_repo = true
      $libvirt_package = 'libvirt-bin'
      $libvirt_service = 'libvirt-bin'
      $kernel_header_package = "linux-headers-${kernelrelease}"
    }
  }
  $fabric_dev = '%AUTO_DEV%'
  $mgmt_dev = '%AUTO_DEV%'
}
