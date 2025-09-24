class nsxt::params {
  $hiera_key          = 'nsx-t'
  $hiera_yml          = '/etc/hiera/plugins/nsx-t.yaml'
  $plugin_package     = 'python-vmware-nsx'
  $core_plugin        = 'vmware_nsx.plugin.NsxV3Plugin'
  $nsx_plugin_dir     = '/etc/neutron/plugins/vmware'
  $nsx_plugin_config  = '/etc/neutron/plugins/vmware/nsx.ini'
}
