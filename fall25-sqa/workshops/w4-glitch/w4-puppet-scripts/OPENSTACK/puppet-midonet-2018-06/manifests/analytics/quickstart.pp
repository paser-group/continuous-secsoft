# == Class: midonet::analytics::quickstart
# Check out the midonet::analytics class for a full understanding of
# how to use the midonet::analytics resource
#
# Configures analytics box for NSDB node access
#
# === Parameters
# [*config_path*]
# Path for storing the zookeeper configuration file.
# Default: /etc/midonet/midonet.conf
#
# [*zookeeper_hosts*]
#   List of IPs and ports of hosts where Zookeeper is installed
#
# [*config_path*]
#  Path for the analytics configuration file
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


class midonet::analytics::quickstart (
  $zookeeper_hosts,
  $config_path      = '/etc/midonet/midonet.conf',
) {

  if !defined(File['midonet folder']) {
    file { 'midonet folder':
      ensure => 'directory',
      path   => '/etc/midonet',
      owner  => 'root',
      mode   => '0755',
    }
  }

  if !defined(File['set_config']) {
    file { 'set_config':
      ensure  => present,
      path    => $config_path,
      content => template('midonet/analytics/midonet.conf.erb'),
      require => File['midonet folder']
    }
  }
}
