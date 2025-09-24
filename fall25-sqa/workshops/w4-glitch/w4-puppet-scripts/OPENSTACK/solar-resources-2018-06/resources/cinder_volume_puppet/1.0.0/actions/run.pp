$resource = hiera($::resource_name)

$package_ensure    = $resource['input']['package_ensure']
$use_iscsi_backend    = $resource['input']['use_iscsi_backend']

$iscsi_ip_address  = $resource['input']['iscsi_ip_address']
$volume_driver     = $resource['input']['volume_driver']
$volume_group      = $resource['input']['volume_group']
$iscsi_helper      = $resource['input']['iscsi_helper']

include cinder::params

package { 'cinder':
  ensure  => $package_ensure,
  name    => $::cinder::params::package_name,
} ->

class {'cinder::volume':
  package_ensure    => $package_ensure,
  enabled           => true,
  manage_service    => true,
}

if $use_iscsi_backend {
  class {'cinder::volume::iscsi':
    iscsi_ip_address  => $iscsi_ip_address,
    volume_driver     => $volume_driver,
    volume_group      => $volume_group,
    iscsi_helper      => $iscsi_helper,
  }
}