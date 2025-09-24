# Example: managing rally services

class { '::rally::settings':
  cirros_img_url            => 'http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img',
  project_domain            => 'admin',
  resource_deletion_timeout => '120',
}

class { '::rally':
  ensure_package => latest,
}
