#
# Files in this package are licensed under Apache; see LICENSE file.
#
# Copyright (c) 2019 Wind River Systems, Inc.
#
# SPDX-License-Identifier: Apache-2.0
#
# Jan 2019 Creation based off puppet-sysinv
#

#
# == Parameters
#
# [use_syslog]
#   Use syslog for logging.
#   (Optional) Defaults to false.
#
# [log_facility]
#   Syslog facility to receive log lines.
#   (Optional) Defaults to LOG_USER.

# dcdbsync instance for containerized openstack services
class dcdbsync::openstack_init (
  $database_connection         = '',
  $database_idle_timeout       = 3600,
  $database_max_pool_size      = 5,
  $database_max_overflow       = 10,
  $package_ensure              = 'present',
  $use_stderr                  = false,
  $log_file                    = 'dcdbsync_openstack.log',
  $log_dir                     = '/var/log/dcdbsync',
  $use_syslog                  = false,
  $log_facility                = 'LOG_USER',
  $verbose                     = false,
  $debug                       = false,
  $region_name                 = 'RegionOne',
) {

  include dcdbsync::params

  file { $::dcdbsync::params::openstack_conf_file:
    ensure => present,
    mode   => '0600',
  }

  dcdbsync_openstack_config {
    'DEFAULT/verbose':             value => $verbose;
    'DEFAULT/debug':               value => $debug;
  }

  # Automatically add psycopg2 driver to postgresql (only does this if it is missing)
  $real_connection = regsubst($database_connection,'^mysql:','mysql+pymysql:')

  dcdbsync_openstack_config {
    'database/connection':    value => $real_connection, secret => true;
    'database/idle_timeout':  value => $database_idle_timeout;
    'database/max_pool_size': value => $database_max_pool_size;
    'database/max_overflow':  value => $database_max_overflow;
  }

  if $use_syslog {
    dcdbsync_openstack_config {
      'DEFAULT/use_syslog':           value => true;
      'DEFAULT/syslog_log_facility':  value => $log_facility;
    }
  } else {
    dcdbsync_openstack_config {
      'DEFAULT/use_syslog':           value => false;
      'DEFAULT/use_stderr':           value => false;
      'DEFAULT/log_file'  :           value => $log_file;
      'DEFAULT/log_dir'   :           value => $log_dir;
    }
  }

  dcdbsync_openstack_config {
    'keystone_authtoken/region_name':  value => $region_name;
  }
}
