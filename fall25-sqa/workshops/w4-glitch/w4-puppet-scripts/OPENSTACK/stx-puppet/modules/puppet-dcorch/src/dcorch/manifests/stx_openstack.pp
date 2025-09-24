#
# Files in this package are licensed under Apache; see LICENSE file.
#
# Copyright (c) 2019 Wind River Systems, Inc.
#
# SPDX-License-Identifier: Apache-2.0
#

# == Class: dcorch::stx_openstack
#
# Update dcorch configuration with stx openstack settings
#
# === Parameters
#
# [*keystone_admin_password*]
#   The admin password for authentication to containerized keystone
#
# [*keystone_admin_user*]
#   (optional) The admin user name for authentication to containerized keystone
#   Defaults to 'admin'
#
# [*keystone_admin_tenant*]
#   (optional) The tenant of the admin user for authentication to containerized keystone
#   Defaults to 'admin'
#
# [*keystone_identity_uri*]
#   (optional) The uri of containerized keystone
#   Defaults to 'http://keystone.openstack.svc.cluster.local:80'
#

class dcorch::stx_openstack (
  $keystone_admin_password    = undef,
  $keystone_admin_user        = 'admin',
  $keystone_admin_tenant      = 'admin',
  $keystone_identity_uri      = 'http://keystone.openstack.svc.cluster.local:80',
) {

  include ::platform::params

  # configuration for accessing openstack keystone
  if $::platform::params::stx_openstack_applied {
    dcorch_config {
      'openstack_cache/auth_uri': value => "${keystone_identity_uri}/v3";
      'openstack_cache/admin_tenant': value => $keystone_admin_tenant;
      'openstack_cache/admin_username': value => $keystone_admin_user;
      'openstack_cache/admin_password': value => $keystone_admin_password, secret => true;
    }
  } else {
    dcorch_config {
      'openstack_cache/auth_uri': ensure => absent;
      'openstack_cache/admin_tenant': ensure => absent;
      'openstack_cache/admin_username': ensure => absent;
      'openstack_cache/admin_password': ensure => absent;
    }
  }
}
