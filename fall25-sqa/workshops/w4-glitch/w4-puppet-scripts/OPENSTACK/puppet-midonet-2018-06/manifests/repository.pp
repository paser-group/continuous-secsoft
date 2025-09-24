# == Class: midonet::repository
#
# Prepare the midonet repositories to install packages.
#
# === Parameters
#
# [*is_mem*]
#  Whether using MEM (true) or OSS Midonet (false)
#    Default: false
#
# [*midonet_version*]
# Midonet version to deploy.
#     Default: '5.2'
#
# [*midonet_stage*]
# Midonet stage to deploy 'unstable' , 'stable' ...
#     Default: 'stable'
#
# [*openstack_release*]
# Openstack release
#     Default: 'mitaka'
#
# [*mem_version*]
# Midonet MEM version to deploy.
#     Default: '5.2'
#
# [*mem_username*]
# MEM repository username
#     Default: undef
#
# [*mem_password*]
# MEM repository password
#     Default: undef
# === Examples
#
# The easiest way to run the class is:
#
#      include midonet::repository
#
# And puppet will configure the system to use the latest stable version
# of MidoNet OSS.
#
# To install other releases than the last default's Midonet OSS, you can
# override the default's midonet_repository atributes by a resource-like
# declaration:
#
#     class { 'midonet::repository':
#          midonet_version         => '5.2',
#          mem_version             => '5.2',
#          openstack_release       => 'mitaka'
#          mem_username            => 'username',
#          mem_password            => 'passw0rd'
#     }
#
# or use a YAML file using the same attributes, accessible from Hiera:
#
#     midonet::repository::midonet_version: '5.2'
#     midonet::repository::mem_version: '5.2'
#     midonet::repository::openstack_release: 'mitaka'
#     midonet::repository::mem_username: 'username'
#     midonet::repository::mem_password: 'passw0rd'
#
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
class midonet::repository (
  $is_mem                 = false,
  $midonet_version        = '5.2',
  $midonet_stage          = 'stable',
  $openstack_release      = 'mitaka',
  $mem_version            = '5.2',
  $mem_username           = undef,
  $mem_password           = undef
  ) {

    case $::osfamily {
      'Debian': {
        class { 'midonet::repository::ubuntu':
          is_mem            => $is_mem,
          midonet_version   => $midonet_version,
          midonet_stage     => $midonet_stage,
          openstack_release => $openstack_release,
          mem_version       => $mem_version,
          mem_username      => $mem_username,
          mem_password      => $mem_password
        }
      }

      'RedHat': {
        class { 'midonet::repository::centos':
          is_mem            => $is_mem,
          midonet_version   => $midonet_version,
          midonet_stage     => $midonet_stage,
          openstack_release => $openstack_release,
          mem_version       => $mem_version,
          mem_username      => $mem_username,
          mem_password      => $mem_password
        }
      }

      default: {
        fail('Operating system not supported by this module')
      }
  }
}
