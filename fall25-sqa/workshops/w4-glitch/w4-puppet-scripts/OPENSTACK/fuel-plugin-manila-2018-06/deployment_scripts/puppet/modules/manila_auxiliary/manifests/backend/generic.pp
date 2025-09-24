define manila_auxiliary::backend::generic (
  $share_driver                 = 'manila.share.drivers.generic.GenericShareDriver',
  $driver_handles_share_servers = 'True',
  $service_instance_user        = 'manila',
  $service_instance_password    = 'manila',
  $service_image_name           = 'manila-service-image',
  $path_to_private_key          = '/root/.ssh/id_rsa',
  $path_to_public_key           = '/root/.ssh/id_rsa.pub',
  $share_backend_name           = $name,
  ) {

  manila_config {
    "${name}/share_driver":                        value => $share_driver;
    "${name}/driver_handles_share_servers":        value => $driver_handles_share_servers;
    "${name}/service_instance_user":               value => $service_instance_user;
    "${name}/service_instance_password":           value => $service_instance_password;
    "${name}/service_image_name":                  value => $service_image_name;
    "${name}/path_to_private_key":                 value => $path_to_private_key;
    "${name}/path_to_public_key":                  value => $path_to_public_key;
    "${name}/share_backend_name":                  value => $share_backend_name;
    }~>Service['manila-share']
  }
