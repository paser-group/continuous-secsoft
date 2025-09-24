# The puppet configures OpenStack glance to use ScaleIO via Cinder.


notice('MODULAR: scaleio: glance')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  $all_nodes = hiera('nodes')
  $nodes = filter_nodes($all_nodes, 'name', $::hostname)
  if empty(filter_nodes($nodes, 'role', 'primary-controller')) and empty(filter_nodes($nodes, 'role', 'controller')) {
    fail("glance task should be run only on controllers, but node ${::hostname} is not controller")
  }
  if $scaleio['use_scaleio_for_glance'] {
    class {'scaleio_openstack::glance':
    }
  } else {
    notify { 'Skip glance configuration': }
  }
}
