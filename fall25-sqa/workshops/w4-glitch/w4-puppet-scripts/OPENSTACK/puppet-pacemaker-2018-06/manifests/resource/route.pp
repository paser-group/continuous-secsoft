# == Define: pacemaker::resource::lsb
#
# See pacemaker::resource::service.  Typical usage is to declare
# pacemaker::resource::service rather than this resource directly.
#
# === Parameters:
#
# [*ensure*]
#   (optional) Whether to make sure the constraint is present or absent
#   Defaults to present
#
# [*src*]
#   (optional) Route source
#   Defaults to ''
#
# [*dest*]
#   (optional) Route destination
#   Defaults to ''
#
# [*gateway*]
#   (optional) Gateway to use
#   Defaults to ''
#
# [*nic*]
#   (optional) Network interface to use
#   Defaults to ''
#
# [*clone_params*]
#   (optional) Additional clone parameters to pass to "pcs create".  Use ''
#   or true for to pass --clone to "pcs resource create" with no addtional
#   clone parameters
#   Defaults to undef
#
# [*group_params*]
#   (optional) Additional group parameters to pass to "pcs create", typically
#   just the name of the pacemaker resource group
#   Defaults to undef
#
# [*bundle*]
#   (optional) Bundle id that this resource should be part of
#   Defaults to undef
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
define pacemaker::resource::route(
  $ensure             = 'present',
  $src                = '',
  $dest               = '',
  $gateway            = '',
  $nic                = '',
  $clone_params       = undef,
  $group_params       = undef,
  $bundle             = undef,
  $post_success_sleep = 0,
  $tries              = 1,
  $try_sleep          = 0,
  $verify_on_create   = false,
  $location_rule      = undef,
  $deep_compare       = false,
) {

  $nic_option = $nic ? {
      ''      => '',
      default => " device=${nic}"
  }

  $src_option = $src ? {
      ''      => '',
      default => " source=${src}"
  }

  $dest_option = $dest ? {
      ''      => '',
      default => " destination=${dest}"
  }

  $gw_option = $gateway ? {
      ''      => '',
      default => " gateway=${gateway}"
  }

  pcmk_resource { "route-${name}":
    ensure             => $ensure,
    resource_type      => 'Route',
    resource_params    => "${dest_option} ${src_option} ${nic_option} ${gw_option}",
    group_params       => $group_params,
    clone_params       => $clone_params,
    bundle             => $bundle,
    post_success_sleep => $post_success_sleep,
    tries              => $tries,
    try_sleep          => $try_sleep,
    verify_on_create   => $verify_on_create,
    location_rule      => $location_rule,
    deep_compare       => $deep_compare,
  }

}
