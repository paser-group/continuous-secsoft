$resource = hiera($::resource_name)

$scheduler_driver  = $resource['input']['scheduler_driver']
$package_ensure    = $resource['input']['package_ensure']

include cinder::params

package { 'cinder':
  ensure  => $package_ensure,
  name    => $::cinder::params::package_name,
} ->

class {'cinder::scheduler':
  scheduler_driver  => $scheduler_driver,
  package_ensure    => $package_ensure,
  enabled           => true,
  manage_service    => true,
}
