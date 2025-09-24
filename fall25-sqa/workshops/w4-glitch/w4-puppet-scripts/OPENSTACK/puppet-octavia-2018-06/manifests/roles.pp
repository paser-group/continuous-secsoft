# == Class: octavia::roles
#
# Configure the octavia roles
#
# === Parameters
#
# [*role_names*]
#   (optional) Create keystone roles to comply with Octavia policies.
#   Defaults to ['load-balancer_observer', 'load-balancer_global_observer',
#   'load-balancer_member', 'load-balancer_quota_admin', 'load-balancer_admin',
#   'admin']
#
class octavia::roles (
  $role_names = [
      'load-balancer_observer',
      'load-balancer_global_observer',
      'load-balancer_member',
      'load-balancer_quota_admin',
      'load-balancer_admin',
      'admin'
      ]
  ) {
  if $role_names {
    keystone_role { $role_names:
      ensure => present
    }
  }
}
