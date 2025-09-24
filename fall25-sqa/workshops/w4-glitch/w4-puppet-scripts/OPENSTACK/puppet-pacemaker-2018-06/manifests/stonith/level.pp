# == Define: pacemaker::stonith::level
#
# A resource type to create pacemaker stonith levels
#
# === Parameters
#
# [*level*]
#   (required) The stonith level
#
# [*target*]
#   (required) The stonith level target
#
# [*stonith_resources*]
#   (required) Array containing the list of stonith devices
#
# [*ensure*]
#   (optional) Whether to make sure resource is created or removed
#   Defaults to present
#
# [*post_success_sleep*]
#   (optional) How long to wait acfter successful action
#   Defaults to 0
#
# [*tries*]
#   (optional) How many times to attempt to perform the action
#   Defaults to 1
#
# [*try_sleep*]
#   (optional) How long to wait between tries
#   Defaults to 0
#
# [*verify_on_create*]
#   (optional) Whether to verify creation of resource
#   Defaults to false
#
# === Dependencies
#
#  None
#
# === Authors
#
#  Michele Baldessari <michele@acksyn.org>
#
# === Copyright
#
# Copyright (C) 2017 Red Hat Inc.
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
define pacemaker::stonith::level(
  $level,
  $target,
  $stonith_resources,
  $ensure             = 'present',
  $post_success_sleep = 0,
  $tries              = 1,
  $try_sleep          = 0,
  $verify_on_create   = false,
  ) {
  if $level == undef {
    fail('Must provide level')
  }
  if $target == undef {
    fail('Must provide target')
  }
  if $stonith_resources == undef {
    fail('Must provide stonith_resources')
  }
  $res = join($stonith_resources, '_')
  pcmk_stonith_level{ "stonith-level-${level}-${target}-${res}":
    ensure             => $ensure,
    level              => $level,
    target             => $target,
    stonith_resources  => $stonith_resources,
    post_success_sleep => $post_success_sleep,
    tries              => $tries,
    try_sleep          => $try_sleep,
    verify_on_create   => $verify_on_create,
  }
}
