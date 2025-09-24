# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: pacemaker::remote
#
# Pacemaker remote manifest. This class is a small helper to set up a pacemaker
# remote node. It does not create the pacemaker-remote resource in the CIB but only
# sets up the remote service
#
# === Parameters
#
# [*remote_authkey*]
#   (Required) Authkey for pacemaker remote nodes
#   Defaults to undef
#
class pacemaker::remote ($remote_authkey) {
  include ::pacemaker::params
  ensure_resource('package', $::pacemaker::params::pcmk_remote_package_list, {
    ensure => present
  })
  Package<| title == 'pacemaker-remote' |> -> File <| title == 'etc-pacemaker' |>

  file { 'etc-pacemaker':
    ensure => directory,
    path   => '/etc/pacemaker',
    owner  => 'hacluster',
    group  => 'haclient',
    mode   => '0750',
  } ->
  file { 'etc-pacemaker-authkey':
    path    => '/etc/pacemaker/authkey',
    owner   => 'hacluster',
    group   => 'haclient',
    mode    => '0640',
    content => $remote_authkey,
  } ->
  service { 'pacemaker_remote':
    ensure => running,
    enable => true,
  }
}
