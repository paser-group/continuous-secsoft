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

# cleanup openstack dcdbsync instance
class dcdbsync::openstack_cleanup {

  include dcdbsync::params

  file { $::dcdbsync::params::openstack_conf_file:
    ensure => absent,
  }
}
