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

class plumgrid::repo (
  $ensure = 'present',
  $os_release = 'icehouse',
  $repo_baseurl,
  $repo_component,
) {
  if $ensure == 'present' {
    case $::osfamily {
      'RedHat', 'Linux': {
        if $repo_baseurl and $repo_baseurl != '' {
          yumrepo { 'plumgrid':
            baseurl => "${repo_baseurl}/${repo_component}/el${operatingsystemmajrelease}/${architecture}",
            descr => "PLUMgrid Repo",
            enabled => 1,
            gpgcheck => 1,
            gpgkey => "${repo_baseurl}/GPG-KEY",
          }
        }
      }
      'Debian': {
        apt::source { 'openstack':
          location => 'http://ubuntu-cloud.archive.canonical.com/ubuntu',
          release => "${::lsbdistcodename}-updates/${os_release}",
          repos => 'main',
          key => 'ECD76E3E',
          key_server => 'keyserver.ubuntu.com',
          include_src => false,
        }
        Apt::Source['openstack'] -> Package['plumgrid-lxc']
      }
      default: {
        fail("Unsupported repository for osfamily: ${::osfamily}, OS: ${::operatingsystem}, module ${module_name}")
      }
    }
  } else {
    case $::osfamily {
      'RedHat', 'Linux': {
        if $repo_baseurl and $repo_baseurl != '' {
          yumrepo { 'plumgrid': ensure => absent, }
        }
      }
      'Debian': {
        apt::source { 'openstack': ensure => absent, }
      }
    }
  }
}
