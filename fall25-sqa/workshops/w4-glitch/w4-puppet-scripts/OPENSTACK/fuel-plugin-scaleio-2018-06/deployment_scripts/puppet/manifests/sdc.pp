# The puppet installs ScaleIO SDC packages and connect to MDMs.
# It expects that any controller could be MDM

notice('MODULAR: scaleio: sdc')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if ! $::controller_ips {
    fail('Empty Controller IPs configuration')
  }
  $all_nodes = hiera('nodes')
  $nodes = filter_nodes($all_nodes, 'name', $::hostname)
  $is_compute = !empty(filter_nodes($nodes, 'role', 'compute'))
  $is_cinder = !empty(filter_nodes($nodes, 'role', 'cinder'))
  $is_glance = (!empty(filter_nodes($nodes, 'role', 'primary-controller')) or !empty(filter_nodes($nodes, 'role', 'controller'))) and $scaleio['use_scaleio_for_glance']
  $need_sdc = $is_compute or $is_cinder or $is_glance
  if $need_sdc {
    class {'::scaleio::sdc_server':
      ensure => 'present',
      mdm_ip => $::controller_ips,
    }
  } else{
    notify {"Skip SDC server task on the node ${::hostname}": }
  }
}

