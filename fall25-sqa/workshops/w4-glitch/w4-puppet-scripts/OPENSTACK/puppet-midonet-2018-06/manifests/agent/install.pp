# == Class: midonet::agent::install
#
# Installs the midonet agent and optionally Java
#
# === Parameters
#
# [*package_name*]
#   Name of the package in the repository. Default: 'midolman'
#
# [*package_ensure*]
#   Whether the package should be installed or not. Default: 'present'
#
# [*manage_java*]
#   Set to true to install java. Defaults to true.
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
class midonet::agent::install (
  $package_name = 'midolman',
  $package_ensure = 'present',
  $manage_java = false,
) {


  if $manage_java {
    case $::osfamily {
      'Debian': {
        include apt
        if $::lsbdistrelease == '16.04' {
          # Placeholder so the default case does not fail
        }
        elsif $::lsbdistrelease == '14.04' {
          package { 'software-properties-common': ensure => installed }
          apt::ppa { 'ppa:openjdk-r/ppa':
            ensure  => present,
            require => Package['software-properties-common'],
            before  => Package[$package_name],
          }
        }
        else {
          fail("Can't manage Java on ${::lsbdistid} ${::lsbdistrelease}")
        }
      }
      'RedHat': {
        # Placeholder so the default case does not fail
      }
      default: {
        fail("Java cannot be managed on ${::osfamily}-based systems")
      }
    }
  }

  case $::osfamily {
    'Debian': {
      package { 'midolman':
        ensure => $package_ensure,
        name   => $package_name,
      }
    }
    'RedHat': {
      package { 'midolman':
        ensure => $package_ensure,
        name   => $package_name,
      }
    }
    default: {
      fail("Midonet agent cannot be installed on ${::osfamily}-based systems")
    }
  }
}
