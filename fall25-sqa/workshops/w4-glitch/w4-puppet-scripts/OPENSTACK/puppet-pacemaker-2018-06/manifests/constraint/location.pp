# == Define: pacemaker::constraint::location
#
# Manages constraint on location of a resource
#
# === Parameters:
#
# [*resource*]
#   (required) The name of the resource to be constrained
#
# [*location*]
#   (required) Specific location to place a resource
#
# [*score*]
#   (required) Numeric score to weight the importance of the constraint
#
# [*tries*]
#   (optional) How many times to attempt to create the constraint
#   Defaults to 1
#
# [*try_sleep*]
#   (optional) How long to wait between tries, in seconds
#   Defaults to 0
#
# [*ensure*]
#   (optional) Whether to make sure the constraint is present or absent
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
define pacemaker::constraint::location (
  $resource,
  $location,
  $score,
  $ensure    = 'present',
  $tries     = 1,
  $try_sleep = 0,
) {
  pcmk_constraint {"loc-${resource}-${location}":
    ensure          => $ensure,
    constraint_type => location,
    resource        => $resource,
    location        => $location,
    score           => $score,
    tries           => $tries,
    try_sleep       => $try_sleep,
  }
}
