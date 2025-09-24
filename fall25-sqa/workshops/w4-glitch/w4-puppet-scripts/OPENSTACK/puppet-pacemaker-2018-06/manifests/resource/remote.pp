# == Define: pacemaker::resource::remote
#
# A resource type to create pacemaker remote resources
#
# === Parameters:
#
# [*ensure*]
#   (optional) Whether to make sure the constraint is present or absent
#   Defaults to present
#
# [*remote_address*]
#   (optional) Address of the remote resource
#   Defaults to undef in which case the name used to create the resource will
#   be used
#
# [*reconnect_interval*]
#   (optional) Remote reconnection interval
#   Defaults to 60 seconds
#
# [*resource_params*]
#   (optional) Any additional parameters needed by pcs for the resource to be
#   properly configured
#   Defaults to ''
#
# [*meta_params*]
#   (optional) Additional meta parameters to pass to "pcs create"
#   Defaults to ''
#
# [*op_params*]
#   (optional) Additional op parameters to pass to "pcs create"
#   Defaults to ''
#
# [*bundle*]
#   (optional) Bundle id that this resource should be part of
#   Defaults to undef
#
# [*tries*]
#   (optional) How many times to attempt to create the resource
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
# [*location_rule*]
#   (optional) Add a location constraint before actually enabling
#   the resource. Must be a hash like the following example:
#   location_rule => {
#     resource_discovery => 'exclusive',    # optional
#     role               => 'master|slave', # optional
#     score              => 0,              # optional
#     score_attribute    => foo,            # optional
#     # Multiple expressions can be used
#     expression         => ['opsrole eq controller']
#   }
#   Defaults to undef
#
# [*deep_compare*]
#   (optional) Enable deep comparing of resources and bundles
#   When set to true a resource will be compared in full (options, meta parameters,..)
#   to the existing one and in case of difference it will be repushed to the CIB
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
define pacemaker::resource::remote(
  $ensure             = 'present',
  $remote_address     = undef,
  $reconnect_interval = 60,
  $resource_params    = '',
  $meta_params        = '',
  $op_params          = '',
  $bundle             = undef,
  $tries              = 1,
  $try_sleep          = 0,
  $verify_on_create   = false,
  $location_rule      = undef,
  $deep_compare       = false,
) {
  pcmk_resource { $name:
    ensure             => $ensure,
    resource_type      => 'remote',
    remote_address     => $remote_address,
    reconnect_interval => $reconnect_interval,
    resource_params    => $resource_params,
    meta_params        => $meta_params,
    op_params          => $op_params,
    bundle             => $bundle,
    tries              => $tries,
    try_sleep          => $try_sleep,
    verify_on_create   => $verify_on_create,
    location_rule      => $location_rule,
    deep_compare       => $deep_compare,
  }
}
