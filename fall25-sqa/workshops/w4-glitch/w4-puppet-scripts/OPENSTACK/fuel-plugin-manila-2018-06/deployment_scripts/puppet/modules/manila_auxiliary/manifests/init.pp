# Class: manila_auxiliary
# ===========================
#
# Full description of class manila_auxiliary here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'manila_auxiliary':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#

class manila_auxiliary (
  $sql_connection      = $sql_conn,
  $shared_backends     = undef,
  $amqp_durable_queues = 'False',
  $rabbit_userid       = 'nova',
  $rabbit_hosts        = undef,
  $rabbit_use_ssl      = 'False',
  $rabbit_password     = undef,
  $ssl_cert_source     = undef,
  $auth_url            = undef,
  $auth_uri            = undef,
  $cinder_pass         = undef,
  $br_mgmt_ip          = undef,
  $manila_pass         = undef,
  $neutron_pass        = undef,
  $nova_pass           = undef,
  $project_domain_id   = 'default',
  $project_name        = 'services',
  $user_domain_id      = 'default',
  $project_domain_name = 'Default',
  $verbose             = $verbose,
  $debug               = $debug,
  ) {

    $lcfs = '%(asctime)s.%(msecs)d %(color)s%(levelname)s %(name)s %(request_id)s %(user_id)s %(project_id)s%(color)s] %(instance)s%(color)s%(message)s'
    $ldfs = '%(asctime)s.%(msecs)d %(color)s%(levelname)s %(name)s -%(color)s %(instance)s%(color)s%(message)s'
    $ldeb = 'from (pid=%(process)d) %(funcName)s %(pathname)s:%(lineno)d'
    $lep  = '%(color)s%(asctime)s.%(msecs)d TRACE %(name)s %(instance)s'

    $scheduler_driver = 'manila.scheduler.drivers.filter.FilterScheduler'

    manila_config {
      'DEFAULT/api_paste_config':              value => '/etc/manila/api-paste.ini';
      'DEFAULT/state_path':                    value => '/var/lib/manila';
      'DEFAULT/osapi_share_extension':         value => 'manila.api.contrib.standard_extensions';
      'DEFAULT/default_share_type':            value => 'default_share_type';
      'DEFAULT/rootwrap_config':               value => '/etc/manila/rootwrap.conf';
      'DEFAULT/auth_strategy':                 value => 'keystone';
      'DEFAULT/enabled_share_backends':        value => $shared_backends;
      'DEFAULT/enabled_share_protocols':       value => 'NFS,CIFS';
      'DEFAULT/share_name_template':           value => 'share-%s';
      'DEFAULT/scheduler_driver':              value => $scheduler_driver;
      'DEFAULT/debug':                         value => $debug;
      'DEFAULT/logging_context_format_string': value => $lcfs;
      'DEFAULT/logging_default_format_string': value => $ldfs;
      'DEFAULT/logging_debug_format_suffix':   value => $ldeb;
      'DEFAULT/logging_exception_prefix':      value => $lep;
      'DEFAULT/rpc_backend':                   value => 'rabbit';
    }
    manila_config {
      'oslo_messaging_rabbit/amqp_durable_queues': value => $amqp_durable_queues;
      'oslo_messaging_rabbit/rabbit_hosts':        value => $rabbit_hosts;
      'oslo_messaging_rabbit/rabbit_use_ssl':      value => $rabbit_use_ssl;
      'oslo_messaging_rabbit/rabbit_userid':       value => $rabbit_userid;
      'oslo_messaging_rabbit/rabbit_password':     value => $rabbit_password;
      'oslo_messaging_rabbit/rabbit_virtual_host': value => '/';
      'oslo_messaging_rabbit/rabbit_ha_queues':    value => 'True';
      'oslo_messaging_rabbit/heartbeat_rate':      value => '2';
    }
    manila_config {
      'oslo_concurrency/lock_path': value => '/var/lib/manila/tmp';
    }
    manila_config {
      'database/connection': value => $sql_connection;
    }
    manila_config {
      'cinder/auth_url':          value => $auth_url;
      'cinder/auth_type':         value => 'password';
      'cinder/password':          value => $cinder_pass;
      'cinder/project_domain_id': value => $project_domain_id;
      'cinder/project_name':      value => $project_name;
      'cinder/user_domain_id':    value => $user_domain_id;
      'cinder/username':          value => 'cinder';
    }
    manila_config {
      'keystone_authtoken/auth_uri':          value => $auth_uri;
      'keystone_authtoken/signing_dir':       value => '/tmp/keystone-signing-manila';
      'keystone_authtoken/memcached_servers': value => "${br_mgmt_ip}:11211";
      'keystone_authtoken/admin_password':    value => $manila_pass;
      'keystone_authtoken/admin_tenant_name': value => $project_name;
      'keystone_authtoken/identity_uri':      value => $auth_uri;
      'keystone_authtoken/admin_user':        value => 'manila';
      'keystone_authtoken/signing_dirname':   value => '/tmp/keystone-signing-manila';
    }
    manila_config {
      'neutron/auth_url':            value => $auth_url;
      'neutron/auth_type':           value => 'password';
      'neutron/password':            value => $neutron_pass;
      'neutron/project_domain_id':   value => $project_domain_id;
      'neutron/project_domain_name': value => $project_domain_name;
      'neutron/project_name':        value => $project_name;
      'neutron/user_domain_id':      value => $user_domain_id;
      'neutron/username':            value => 'neutron';
    }
    manila_config {
      'nova/auth_url':          value => $auth_url;
      'nova/auth_type':         value => 'password';
      'nova/password':          value => $nova_pass;
      'nova/project_domain_id': value => $project_domain_id;
      'nova/project_name':      value => $project_name;
      'nova/user_domain_id':    value => $user_domain_id;
      'nova/username':          value => 'nova';
    }

    if $ssl_cert_source in 'self_signed' {
      manila_config {
        'nova/api_insecure':   value => True;
        'nova/insecure':       value => True;
        'neutron/insecure':    value => True;
        'cinder/api_insecure': value => True;
        'cinder/insecure':     value => True;
      }
    }
}
