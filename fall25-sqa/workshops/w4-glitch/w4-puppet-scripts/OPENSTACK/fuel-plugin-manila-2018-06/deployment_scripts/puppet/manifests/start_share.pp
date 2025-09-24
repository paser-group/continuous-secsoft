#    Copyright 2016 Mirantis, Inc.
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

notify {'MODULAR: fuel-plugin-manila/start_share': }

$srv  = 'manila-share'
$desc = 'manila-share service'

$fuel_manila_hash = hiera_hash('fuel-plugin-manila', {})
$manila           = hiera_hash('manila', {})
$image            = $manila['service_vm_image']['img_name']


if $fuel_manila_hash['use-generic-driver'] {
  $generic_share_driver     = 'manila.share.drivers.generic.GenericShareDriver'
  $generic_backends = {'generic' =>
    {'share_backend_name'            => 'generic',
      'driver_handles_share_servers' => 'true',
      'share_driver'                 => $generic_share_driver,
      'service_instance_user'        => 'manila',
      'service_instance_password'    => 'manila',
      'service_image_name'           => $image,
      'path_to_private_key'          => '/var/lib/astute/manila/manila',
      'path_to_public_key'           => '/var/lib/astute/manila/manila.pub',
    }
  }
  create_resources('::manila_auxiliary::backend::generic', $generic_backends)
}

if $fuel_manila_hash['use-netapp-driver'] {
  $netapp_backends = {'cdotMultipleSVM' =>
    {'netapp_transport_type'                => $fuel_manila_hash['netapp-proto'],
     'netapp_server_hostname'               => $fuel_manila_hash['netapp-host'],
     'netapp_server_port'                   => $fuel_manila_hash['netapp-port'],
     'netapp_login'                         => $fuel_manila_hash['netapp-user'],
     'netapp_password'                      => $fuel_manila_hash['netapp-pass'],
     'netapp_root_volume_aggregate'         => $fuel_manila_hash['netapp-root_volume_aggregate'],
     'netapp_port_name_search_pattern'      => $fuel_manila_hash['netapp-port_name_search_pattern'],
     'netapp_aggregate_name_search_pattern' => $fuel_manila_hash['netapp_aggregate_name_search_pattern'],
    }
  }
  create_resources('::manila_auxiliary::backend::netapp', $netapp_backends)
}

$inits = {
  'manila-share' => {
    desc => 'manila-share init script',
    srv  => 'manila-share',},
}

create_resources('::manila_auxiliary::initd', $inits)

notify {'Restart manila-share':
  }~>
  service { 'manila-share':
    ensure    => 'running',
    name      => 'manila-share',
    enable    => true,
    hasstatus => true,
  }
