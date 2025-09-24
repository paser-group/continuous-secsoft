# == Class: midonet::midonet_api::install
# Check out the midonet::midonet_api class for a full understanding of
# how to use the midonet_api resource
# === Parameters
#
# [*package_ensure*]
#   Status to ensure for the midonet cluster package
#   Default: 'present'
#
# [*package_name*]
#   Name of the midonet cluster package
#   Default: 'midonet-cluster'
#
# [*is_mem*]
#   Whether or not install the MEM related packages
#   Default: false
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
class midonet::cluster::install (
  $package_ensure    = 'present',
  $package_name      = 'midonet-cluster',
  $is_mem            = false
) {

  package { 'midonet-cluster':
    ensure => $package_ensure,
    name   => $package_name,
  }

  if $is_mem {
    package { 'midonet-cluster-mem':
      ensure  => $package_ensure
    }
  }
  else  {
    notice('Skipping installation of midonet-cluster-mem')
  }

}
