# == Class: midonet::repository::centos
# NOTE: don't use this class, use midonet::repository(::init) instead
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
#
# === Authors
#
# Midonet (http://midonet.org)
#
# === Copyright
#
# Copyright (c) 2016 Midokura SARL, All Rights Reserved.
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

class midonet::repository::centos (
  $is_mem,
  $midonet_version,
  $midonet_stage,
  $openstack_release,
  $mem_version,
  $mem_username,
  $mem_password,
) {
  include midonet::params

  # Notify the user about we are doing
  notice('Adding midonet repositories for RedHat-based distribution')

  # Prefix the repository name differently if we're installing MEM
  if $is_mem {
    $midonet_repo_prefix        = 'mem'
    $midonet_core_repo_url      = "http://${mem_username}:${mem_password}@${midonet::params::midonet_repo_baseurl}/mem-${mem_version}/${midonet_stage}/el${::operatingsystemmajrelease}"
  } else {
    $midonet_repo_prefix        = 'midonet'
    $midonet_core_repo_url      = "http://${midonet::params::midonet_repo_baseurl}/midonet-${midonet_version}/${midonet_stage}/el${::operatingsystemmajrelease}"
  }

  if $::operatingsystemmajrelease == '7' {
    yumrepo { 'midonet':
      name     => $midonet_repo_prefix,
      baseurl  => $midonet_core_repo_url,
      descr    => 'Base repository',
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => $midonet::params::midonet_key_url,
      timeout  => 60
    }
    yumrepo { 'midonet-openstack-integration':
      name     => "${midonet_repo_prefix}-openstack-integration",
      baseurl  => "http://${midonet::params::midonet_repo_baseurl}/openstack-${openstack_release}/${midonet_stage}/el${::operatingsystemmajrelease}",
      descr    => 'OpenStack integration',
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => $midonet::params::midonet_key_url,
      timeout  => 60
    }
    yumrepo { 'midonet-misc':
      name     => "${midonet_repo_prefix}-misc",
      baseurl  => "http://${midonet::params::midonet_repo_baseurl}/misc/${midonet_stage}/el${::operatingsystemmajrelease}",
      descr    => '3rd party tools and libraries',
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => $midonet::params::midonet_key_url,
      timeout  => 60
    }
  }
  else
  {
    fail("RedHat/CentOS version ${::operatingsystemmajrelease} not supported")
  }
}
