# == Define: pacemaker::property
#
# === Parameters:
#
# [*property*]
#   (required) Name of the property to set or remove
#
# [*value*]
#   (optional) Value to set the property to, required if ensure is set to
#   present
#   Defaults to undef
#
# [*node*]
#   (optional) Specific node to set the property on
#   Defaults to undef
#
# [*force*]
#   (optional) Whether to force creation of the property
#   Defaults to false
#
# [*ensure*]
#   (optional) Whether to make sure the constraint is present or absent
#   Defaults to present
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
define pacemaker::property (
  $property,
  $value     = undef,
  $node      = undef,
  $force     = false,
  $ensure    = present,
  $tries     = 1,
  $try_sleep = 10,
) {
  if $property == undef {
    fail('Must provide property')
  }
  if ($ensure == 'present') and $value == undef {
    fail('When present, must provide value')
  }

  pcmk_property { "property-${node}-${property}":
    ensure    => $ensure,
    property  => $property,
    value     => $value,
    node      => $node,
    force     => $force,
    tries     => $tries,
    try_sleep => $try_sleep,
  }
}
