# == Define: pacemaker::resource::ip
#
# A resource type to create pacemaker IPaddr2 resources, provided
# for convenience.
#
# === Parameters
#
# [*ensure*]
#   (optional) Whether to make sure resource is created or removed
#   Defaults to present
#
# [*ip_address*]
#   (optional) The virtual IP address you want pacemaker to create and manage
#   Defaults to undef
#
# [*cidr_netmask*]
#   (optional) The netmask to use in the cidr= option in the
#   "pcs resource create"command
#   Defaults to '32'
#
# [*nic*]
#   (optional) The nic to use in the nic= option in the "pcs resource create"
#   command
#   Defaults to ''
#
# [*ipv6_addrlabel*]
#   (optional) The ipv6 label value to be used when creating an ipv6 ip resource
#   It typically gets set to 99 to avoid using the VIP as a source address.
#   Defaults to ''
#
# [*group_params*]
#   (optional) Additional group parameters to pass to "pcs create", typically
#   just the name of the pacemaker resource group
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
define pacemaker::resource::ip(
  $ensure             = 'present',
  $ip_address         = undef,
  $cidr_netmask       = '32',
  $nic                = '',
  $ipv6_addrlabel     = '',
  $group_params       = '',
  $meta_params        = '',
  $op_params          = '',
  $bundle             = undef,
  $post_success_sleep = 0,
  $tries              = 1,
  $try_sleep          = 0,
  $verify_on_create   = false,
  $location_rule      = undef,
  $deep_compare       = hiera('pacemaker::resource::ip::deep_compare', false),
  ) {
  if !is_ipv6_address($ip_address) and $ipv6_addrlabel != '' {
    fail("ipv6_addrlabel ${ipv6_addrlabel} was specified, but ${ip_address} is not an ipv6 address")
  }


  $cidr_option = $cidr_netmask ? {
      ''      => '',
      default => " cidr_netmask=${cidr_netmask}"
  }
  $nic_option = $nic ? {
      ''      => '',
      default => " nic=${nic}"
  }
  $ipv6_addrlabel_option = $ipv6_addrlabel ? {
      ''      => '',
      default => " lvs_ipv6_addrlabel=true lvs_ipv6_addrlabel_value=${ipv6_addrlabel}"
  }

  # pcs dislikes colons from IPv6 addresses. Replacing them with dots.
  $resource_name = regsubst($ip_address, '(:)', '.', 'G')

  pcmk_resource { "ip-${resource_name}":
    ensure             => $ensure,
    resource_type      => 'IPaddr2',
    resource_params    => join(['ip=', $ip_address, $cidr_option, $nic_option, $ipv6_addrlabel_option]),
    group_params       => $group_params,
    meta_params        => $meta_params,
    op_params          => $op_params,
    bundle             => $bundle,
    post_success_sleep => $post_success_sleep,
    tries              => $tries,
    try_sleep          => $try_sleep,
    verify_on_create   => $verify_on_create,
    location_rule      => $location_rule,
    deep_compare       => $deep_compare,
  }

}
