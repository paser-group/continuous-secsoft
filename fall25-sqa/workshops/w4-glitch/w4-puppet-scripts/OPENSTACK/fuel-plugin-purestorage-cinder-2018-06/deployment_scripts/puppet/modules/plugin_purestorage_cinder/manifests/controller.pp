#    Copyright 2015 Pure Storage, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

class plugin_purestorage_cinder::controller (
  $section,
  $glance_image_cache,
  $glance_image_count,
  $glance_image_size,
  $replication,
  $remote_array,
  $remote_ip,
  $remote_api,
  $replication_default,
  $replication_interval,
  $replication_short,
  $replication_long_day,
  $replication_long,
  $eradicate,
  $local_ip,
  $local_api,
  $local_chap,
  $local_multipath,
  $protocol,
  $consis_group,
  $fczm_config,
  $fc_vendor,
  $fabric_count,
  $fabric_name_1,
  $fabric_name_2,
  $fc_ip_1,
  $fc_ip_2,
  $fc_user_1,
  $fc_user_2,
  $fc_passwd_1,
  $fc_passwd_2,
  $fc_prefix_1,
  $fc_prefix_2,
  $fc_vsan_1,
  $fc_vsan_2
) {

  include plugin_purestorage_cinder::common
  include ::cinder::params
  include ::cinder::client
  include ::keystone::client

  ini_subsetting { 'enable_cinder_pure_backend':
    ensure               => present,
    section              => 'DEFAULT',
    key_val_separator    => '=',
    path                 => '/etc/cinder/cinder.conf',
    setting              => 'enabled_backends',
    subsetting           => $section,
    subsetting_separator => ',',
  }

  package { 'purestorage':
    ensure   => 'installed',
    provider => pip
  }

  if $::cinder::params::volume_package {
    package { $::cinder::params::volume_package:
      ensure => present,
    }
    Package[$::cinder::params::volume_package] -> Cinder_config<||>
  }

  #    $section = $backend_name
  cinder_type { 'pure_vol':
    ensure     => present,
    properties => ['volume_backend_name=pure'],
  }
  cinder_config {
    'DEFAULT/default_volume_type': value => 'pure_vol';
    #      'DEFAULT/enabled_backends': value => "${section}";
  }

  if $glance_image_cache{
    cinder_config {
      # Force both cinter internal tenant and user to be a fixed values, keeping plugin idempotent
      'DEFAULT/cinder_internal_tenant_project_id': value => '123456789abcdef123456789abcdef12';
      'DEFAULT/cinder_internal_tenant_user_id': value => '123456789abcdef123456789abcdef13';
      "${section}/image_volume_cache_enabled": value => $glance_image_cache;
      "${section}/image_volume_cache_max_count": value => $glance_image_count;
      "${section}/image_volume_cache_max_size_gb": value => $glance_image_size;
    }
  }

  if $replication == true {
    $repl_device = join(['backend_id:' ,$remote_array,',san_ip:',$remote_ip,',api_token:',$remote_api],'')
    cinder_config {
      "${section}/replication_device": value => $repl_device;
    }
    if $replication_default == 'false' {
      cinder_config {
        "${section}/pure_replica_interval_default": value => $replication_interval;
        "${section}/pure_replica_retention_short_term_default": value => $replication_short;
        "${section}/pure_replica_retention_long_term_per_day_default": value => $replication_long_day;
        "${section}/pure_replica_retention_long_term_default": value => $replication_long;
      }
    }
  }

  if $eradicate == true {
    cinder_config {
      "${section}/pure_eradicate_on_delete": value => $eradicate;
    }
  }

  cinder::backend::pure { $section :
    san_ip                        => $local_ip,
    pure_api_token                => $local_api,
    volume_backend_name           => $section,
    use_chap_auth                 => $local_chap,
    use_multipath_for_image_xfer  => $local_multipath,
    pure_storage_protocol         => $protocol,
    extra_options                 => { "${section}/backend_host" => { value => $section }
    }
  }

  # If consistency groups are selected then provide a modified pilocy.json that enables them
  if $consis_group == true {
    file { 'policy.json':
      path    => '/etc/cinder/policy.json',
      mode    => '0644',
      owner   => cinder,
      group   => cinder,
      source  => 'puppet:///modules/plugin_purestorage_cinder/policy.json',
    }
  }

  # If protocol is FC then meed to add zoning_mode. Put in $section as this has already been set by multibackend
  if ($protocol == 'FC') and ($fczm_config == 'automatic') {
    cinder_config {
      "${section}/zoning_mode": value => 'Fabric';
    }
    # Now add in the [fc-zone-manager] stanza
    case $fc_vendor {
      'Brocade': {
        cinder_config {
          'fc-zone-manager/brcd_sb_connector': value => 'cinder.zonemanager.drivers.brocade.brcd_fc_zone_client_cli.BrcdFCZoneClientCLI';
          'fc-zone-manager/fc_san_lookup_service': value => 'cinder.zonemanager.drivers.brocade.brcd_fc_san_lookup_service.BrcdFCSanLookupService';
          'fc-zone-manager/zone_driver': value => 'cinder.zonemanager.drivers.brocade.brcd_fc_zone_driver.BrcdFCZoneDriver';
        }
      }
      'Cisco': {
        cinder_config {
          'fc-zone-manager/cisco_sb_connector': value => 'cinder.zonemanager.drivers.cisco.cisco_fc_zone_client_cli.CiscoFCZoneClientCLI';
          'fc-zone-manager/fc_san_lookup_service': value => 'cinder.zonemanager.drivers.cisco.cisco_fc_san_lookup_service.CiscoFCSanLookupService';
          'fc-zone-manager/zone_driver': value => 'cinder.zonemanager.drivers.cisco.cisco_fc_zone_driver.CiscoFCZoneDriver';
        }
      }
      default: {
        fail("${fc_vendor} is not a supported FCZM Vendor.")
      }
    }
    case $fabric_count {
      '1': {
        cinder_config {
          'fc-zone-manager/fc_fabric_names': value => $fabric_name_1;
        }
      }
      '2': {
        cinder_config {
          'fc-zone-manager/fc_fabric_names': value => join([$fabric_name_1,', ',$fabric_name_2],'');
        }
      }
      default: {
        fail("Invalid value for fabric_count: ${fabric_count}.")
      }
    }

    $fabric_zone_1 = $fabric_name_1
    $fabric_zone_2 = $fabric_name_2

    # Now add in stanzas for each fabric zone depending on the switch vendor
    case $fc_vendor {
      'Brocade': {
        cinder_config {
          "${fabric_zone_1}/fc_fabric_address": value => $fc_ip_1;
          "${fabric_zone_1}/fc_fabric_user": value => $fc_user_1;
          "${fabric_zone_1}/fc_fabric_password": value => $fc_passwd_1;
          "${fabric_zone_1}/fc_fabric_port": value => '22';
          "${fabric_zone_1}/zoning_policy": value => 'initiator-target';
          "${fabric_zone_1}/zone_activate": value => true;
          "${fabric_zone_1}/zone_name_prefix": value => join([$fabric_name_1,'_'],'');
        }
        if $fabric_count == '2' {
          cinder_config {
            "${fabric_zone_2}/fc_fabric_address": value => $fc_ip_2;
            "${fabric_zone_2}/fc_fabric_user": value => $fc_user_2;
            "${fabric_zone_2}/fc_fabric_password": value => $fc_passwd_2;
            "${fabric_zone_2}/fc_fabric_port": value => '22';
            "${fabric_zone_2}/zoning_policy": value => 'initiator-target';
            "${fabric_zone_2}/zone_activate": value => true;
            "${fabric_zone_2}/zone_name_prefix": value => join([$fabric_name_2,'_'],'');
          }
        }
      }
      'Cisco': {
        cinder_config {
          "${fabric_zone_1}/cisco_fc_fabric_address": value => $fc_ip_1;
          "${fabric_zone_1}/cisco_fc_fabric_user": value => $fc_user_1;
          "${fabric_zone_1}/cisco_fc_fabric_password": value => $fc_passwd_1;
          "${fabric_zone_1}/cisco_fc_fabric_port": value => '22';
          "${fabric_zone_1}/cisco_zoning_vsan": value => $fc_vsan_1;
          "${fabric_zone_1}/cisco_zoning_policy": value => 'initiator-target';
          "${fabric_zone_1}/cisco_zone_activate": value => true;
          "${fabric_zone_1}/cisco_zone_name_prefix": value => join([$fabric_name_1,'_'],'');
        }
        if $fabric_count == '2' {
          cinder_config {
            "${fabric_zone_2}/cisco_fc_fabric_address": value => $fc_ip_2;
            "${fabric_zone_2}/cisco_fc_fabric_user": value => $fc_user_2;
            "${fabric_zone_2}/cisco_fc_fabric_password": value => $fc_passwd_2;
            "${fabric_zone_2}/cisco_fc_fabric_port": value => '22';
            "${fabric_zone_2}/cisco_zoning_vsan": value => $fc_vsan_2;
            "${fabric_zone_2}/cisco_zoning_policy": value => 'initiator-target';
            "${fabric_zone_2}/cisco_zone_activate": value => true;
            "${fabric_zone_2}/cisco_zone_name_prefix": value => join([$fabric_name_2,'_'],'');
          }
        }
      }
      default: {
        fail("${fc_vendor} is not a supported FCZM Vendor.")
      }
    }
  }

  Cinder_config<||> ~> Service['cinder_volume']

  service { 'cinder_volume':
    ensure     => running,
    name       => $::cinder::params::volume_service,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
