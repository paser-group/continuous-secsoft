notify {'MODULAR: fuel-plugin-manila/image_upload': }

$manila = hiera_hash('fuel-plugin-manila', {})
$image  = $manila['fuel-plugin-manila_image']

$master_ip = hiera('master_ip')
$src_image = "http://${master_ip}:8080/plugins/fuel-plugin-manila-1.0/repositories/ubuntu/${image}"


class {'::manila_auxiliary::image':
  src_image => $src_image,
  image     => $image,
}
