# == Define: pacemaker::constraint::order
#
# Creates Order constraints for resources that need specific ordering.
#
# === Parameters:
#
# [*first_resource*]
#   (optional) First resource to be constrained
#   Defaults to undef
#
# [*second_resource*]
#   (optional) Second resource to be constrained
#   Defaults to undef
#
# [*first_action*]
#   (optional) Only used for order constraints, action to take on first resource
#   Defaults to undef
#
# [*second_action*]
#   (optional) Only used for order constraints, action to take on second resource
#   Defaults to undef
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
# [*constraint_params*]
#   (optional) Any additional parameters needed by pcs for the constraint to be
#   properly configured
#   Defaults to undef
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
define pacemaker::constraint::order (
  $first_resource,
  $second_resource,
  $first_action,
  $second_action,
  $ensure            = present,
  $constraint_params = undef,
  $tries             = 1,
  $try_sleep         = 0,
) {
  $first_resource_cleaned  = regsubst($first_resource, '(:)', '.', 'G')
  $second_resource_cleaned = regsubst($second_resource, '(:)', '.', 'G')

  pcmk_constraint {"order-${first_resource}-${second_resource}":
    ensure            => $ensure,
    constraint_type   => order,
    first_resource    => $first_resource_cleaned,
    second_resource   => $second_resource_cleaned,
    first_action      => $first_action,
    second_action     => $second_action,
    constraint_params => $constraint_params,
    tries             => $tries,
    try_sleep         => $try_sleep,
  }
}
