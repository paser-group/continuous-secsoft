# == Class: pacemaker::stonith
#
# Configures the pacemaker property that set whether stonith is enabled or not.
#
# === Parameters:
#
# [*disable*]
#   (optional) Whether to disable stonith
#   Defaults to true
#
# [*tries*]
#   (optional) How many times to attempt to create the constraint
#   Defaults to 1
#
# [*try_sleep*]
#   (optional) How long to wait between tries, in seconds
#   Defaults to 10
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
class pacemaker::stonith (
  $disable   = true,
  $tries     = 1,
  $try_sleep = 10,
) {
  if $disable == true {
    pacemaker::property { 'Disable STONITH':
        property  => 'stonith-enabled',
        value     => false,
        tries     => $tries,
        try_sleep => $try_sleep,
    }
  } else {
    pacemaker::property { 'Enable STONITH':
        property  => 'stonith-enabled',
        value     => true,
        tries     => $tries,
        try_sleep => $try_sleep,
    }
  }
}
