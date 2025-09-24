# == Class: pacemaker::resource_defaults
#
# Defaults to set for pcs resources
#
# === Parameters:
#
# [*defaults*]
#   (required) Comma separated string of key=value pairs specifying defaults.
#
# [*post_success_sleep*]
#   (optional) How long to wait acfter successful action
#   Defaults to 0
#
# [*tries*]
#   (optional) How many times to attempt to create the constraint
#   Defaults to 1
#
# [*try_sleep*]
#   (optional) How long to wait between tries, in seconds
#   Defaults to 0
#
# [*verify_on_create*]
#   (optional) Whether to verify creation of resource
#   Defaults to false
#
# [*ensure*]
#   (optional) Whether to create or remove the defaults
#   Defaults to present
#
# === Dependencies
#
#  None
#
# === Authors
#
#  Crag Wolfe <cwolfe@redhat.com>
#  Jason Guiditta <jguiditt@redhat.com>
#
# === Copyright
#
# Copyright (C) 2016 Red Hat Inc.
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
class pacemaker::resource_defaults(
  $defaults,
  $post_success_sleep = 0,
  $tries              = 1,
  $try_sleep          = 0,
  $verify_on_create   = false,
  $ensure             = 'present',
) {
  create_resources(
    'pcmk_resource_default',
    $defaults,
    {
      ensure             => $ensure,
      post_success_sleep => $post_success_sleep,
      tries              => $tries,
      try_sleep          => $try_sleep,
      verify_on_create   => $verify_on_create,
    }
  )
}
