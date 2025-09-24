# == Class: midonet::cluster::subscription
#
# Manages the Midonet subscription
#
# === Parameters
#
# [*file_contents*]
#   Contents of the subscription file, base64 encoded with the `base64`
#   command, which assumes a column length of 76 (see manpage)
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

class midonet::cluster::subscription (
  $file_contents,
) {

  $midonet_subscriptions_folder = '/etc/midonet/subscriptions'
  $base64_license_file_path     = '/tmp/MidoNet.license.base64'
  $license_file_name            = 'MidoNet.license.subs'

  file { 'subscriptions-folder':
    ensure => directory,
    path   => $midonet_subscriptions_folder,
    before =>  Exec['license-move'],
  }

  file { 'midonet-license':
    ensure  => present,
    path    => $base64_license_file_path,
    content =>  $file_contents,
  } ->

  exec { 'license-move':
    command => "base64 -d ${base64_license_file_path} > ${midonet_subscriptions_folder}/${license_file_name}",
    path    => ['/usr/bin','/bin'],
    require =>  File['subscriptions-folder'],
  }
}
