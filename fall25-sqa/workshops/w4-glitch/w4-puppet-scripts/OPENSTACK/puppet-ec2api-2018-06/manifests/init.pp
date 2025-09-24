# == Class: ec2api
#
# The main EC2 API class to install and configure the service
#
# [*package_manage*]
#   Should the package be actually managed by Puppet?
#   Default: true
#
# [*package_ensure*]
#   The package ensure value. Can be present/absent/latest/purged
#   or the exact package version number.
#   Default: present
#
# [*package_name*]
#   The real package name.
#   Default: openstack-ec2-api
#
# [*package_provider*]
#   Override the provider used to manage the package.
#   Default: undef
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the ec2api config.
#   Defaults to false.
#
class ec2api (
  $package_ensure   = 'present',
  $package_manage   = true,
  $package_name     = $::ec2api::params::package_name,
  $package_provider = undef,
  $purge_config     = false,
) inherits ::ec2api::params {

  include ::ec2api::deps
  include ::ec2api::config
  include ::ec2api::logging
  include ::ec2api::policy
  include ::ec2api::db

  validate_string($package_ensure)
  validate_bool($package_manage)
  validate_string($package_name)

  if $package_manage {
    package { 'ec2api' :
      ensure   => $package_ensure,
      name     => $package_name,
      provider => $package_provider,
      tag      => ['openstack', 'ec2api-package']
    }
  }

  resources { 'ec2api_config':
    purge => $purge_config,
  }

}
