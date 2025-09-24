# == Class: midonet::repository::ubuntu
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

class midonet::repository::ubuntu (
      $is_mem,
      $midonet_version,
      $midonet_stage,
      $openstack_release,
      $mem_version,
      $mem_username,
      $mem_password)
    {


        notice('Adding midonet sources for Debian-like distribution')
        if $::lsbdistrelease == '14.04' or $::lsbdistrelease == '16.04' {
            notice('Adding midonet sources for Debian-like distribution')

            include midonet::params
            include apt
            include apt::update

            if $is_mem {
              $midonet_repo_url = "http://${mem_username}:${mem_password}@${midonet::params::midonet_repo_baseurl}/mem-${mem_version}"
            }
            else {
              $midonet_repo_url = "http://${midonet::params::midonet_repo_baseurl}/midonet-${midonet_version}"
            }
            # Update the package list each time a package is defined. That takes
            # time, but it ensures it will not fail for out of date repository info
            # Exec['apt_update'] -> Package<| |>

            apt::key { 'midorepo':
              id     => 'E9996503AEB005066261D3F38DDA494E99143E75',
              source => $midonet::params::midonet_key_url
            }

            apt::source {'midonet':
                comment  => 'Midonet apt repository',
                location => $midonet_repo_url,
                release  => $midonet_stage,
                key      => {
                      'id'     => 'E9996503AEB005066261D3F38DDA494E99143E75',
                      'server' => 'subkeys.pgp.net',
                },
                include  => {
                      'src' => false,
              }
            }

            apt::source {'midonet-openstack-integration':
                comment  => 'Midonet apt plugin repository',
                location => "http://${midonet::params::midonet_repo_baseurl}/openstack-${openstack_release}",
                release  => $midonet_stage,
                include  => {
                      'src' => false,
              }
            }

            apt::source {'midonet-openstack-misc':
                comment  => 'Midonet 3rd party tools and libraries',
                location => "http://${midonet::params::midonet_repo_baseurl}/misc",
                release  => $midonet_stage,
                include  => {
                      'src' => false,
              }
            }

            # Dummy exec to wrap apt_update
            exec {'update-midonet-repos':
                command => '/bin/true',
                require => [Exec['apt_update'],
                            Apt::Source['midonet'],
                            Apt::Source['midonet-openstack-integration']]

            }

            Apt::Source<| |> -> Exec<| title == 'update-midonet-repos' |>

        }
        else
        {
            fail("${::lsbdistid} ${::lsbdistrelease} version not supported")
        }
    }
