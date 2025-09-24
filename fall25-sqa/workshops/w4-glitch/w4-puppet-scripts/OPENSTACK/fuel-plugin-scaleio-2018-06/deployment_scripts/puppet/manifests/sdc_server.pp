# The puppet installs ScaleIO SDS packages.

notice('MODULAR: scaleio: sdc_server')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  $all_nodes = hiera('nodes')
  $nodes = filter_nodes($all_nodes, 'name', $::hostname)
  $is_compute = !empty(filter_nodes($nodes, 'role', 'compute'))
  $is_cinder = !empty(filter_nodes($nodes, 'role', 'cinder'))
  $is_glance = (!empty(filter_nodes($nodes, 'role', 'primary-controller')) or !empty(filter_nodes($nodes, 'role', 'controller'))) and $scaleio['use_scaleio_for_glance']
  $need_sdc = $is_compute or $is_cinder or $is_glance
  if $need_sdc {
    class {'::scaleio::sdc_server':
      ensure => 'present',
      mdm_ip => undef,
      pkg_ftp => $scaleio['pkg_ftp'],
    }
  } else{
      notify {"Skip SDC server task on the node ${::hostname}": }
  }
}
