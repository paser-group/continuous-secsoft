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

notify {'MODULAR: fuel-plugin-manila/generic': }

$manila       = hiera_hash('manila', {})
$image        = $manila['service_vm_image']['img_name']
$share_driver = 'manila.share.drivers.generic.GenericShareDriver'

$backends = {'generic' =>
  {'share_backend_name'            => 'generic',
    'driver_handles_share_servers' => 'true',
    'share_driver'                 => $share_driver,
    'service_instance_user'        => 'manila',
    'service_instance_password'    => 'manila',
    'service_image_name'           => $image,
    'path_to_private_key'          => '/var/lib/astute/manila/manila',
    'path_to_public_key'           => '/var/lib/astute/manila/manila.pub',
  }
}

create_resources('::manila_auxiliary::backend::generic', $backends)
