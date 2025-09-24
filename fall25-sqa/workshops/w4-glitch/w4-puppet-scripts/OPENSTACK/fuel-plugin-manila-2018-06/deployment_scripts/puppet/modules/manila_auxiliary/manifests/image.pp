class manila_auxiliary::image (
  $src_image = 'http://host/manila-service-image.qcow2',
  $image     = 'manila-service-image.qcow2',
){
  file {'/tmp/upload_cirros.rb':
    source => 'puppet:///modules/manila_auxiliary/upload_cirros.rb',
  }->
  exec {'wget_service_image':
    command => "wget ${src_image} -O /tmp/${image}",
    path    => '/usr/bin',
  }->
  exec {'upload-service-image':
    command => 'ruby /tmp/upload_cirros.rb',
    path    => '/usr/bin',
  }->
  exec {'del_service_image':
    command => "/bin/rm /tmp/${image}",
    path    => '/usr/bin',
  }
}
