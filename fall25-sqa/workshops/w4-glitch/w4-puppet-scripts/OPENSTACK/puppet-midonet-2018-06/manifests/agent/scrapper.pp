# == Class: midonet::agent::scrapper
# Check out the midonet::agent class for a full understanding of
# how to use the midonet::agent resource
# === Authors
#
# Midonet (http://midonet.org)
#
# === Parameters
#
# [*package_name*]
#   Name of the JMXscraper package.
#     Default: 'midonet-jmxscraper'
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

class midonet::agent::scrapper (
  $package_name      = 'midonet-jmxscraper',
) {

  if ($::osfamily == 'RedHat') {
    yumrepo { 'vbernat-lldpd':
      baseurl  => 'http://download.opensuse.org/repositories/home:/vbernat/RHEL_7/',
      descr    => 'vbernat-lldpd',
      enabled  => 1,
      gpgcheck => 1,
      gpgkey   => 'http://download.opensuse.org/repositories/home:/vbernat/RHEL_7//repodata/repomd.xml.key',
      before   => Package['midonet-jmxscraper','lldpd']
    }
}

  package { 'lldpd':
    ensure => present,
    before => Package['midonet-jmxscraper']
  }

  package { 'midonet-jmxscraper':
    ensure => present,
    name   => $package_name,
  }

  service { $package_name:
    ensure  => running,
    enable  => true,
    require => Package[$package_name],
  }

}
