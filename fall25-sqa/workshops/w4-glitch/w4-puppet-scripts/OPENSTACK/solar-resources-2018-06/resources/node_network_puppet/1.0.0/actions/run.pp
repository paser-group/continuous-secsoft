$resource = hiera($::resource_name)

$ensure_package             = $resource['input']['ensure_package']
$use_lnx                    = $resource['input']['use_lnx']
$use_ovs                    = $resource['input']['use_ovs']
$install_ovs                = $resource['input']['install_ovs']
$install_brtool             = $resource['input']['install_brtool']
$install_ethtool            = $resource['input']['install_ethtool']
$install_bondtool           = $resource['input']['install_bondtool']
$install_vlantool           = $resource['input']['install_vlantool']
$ovs_modname                = $resource['input']['ovs_modname']
$ovs_datapath_package_name  = $resource['input']['ovs_datapath_package_name']
$ovs_common_package_name    = $resource['input']['ovs_common_package_name']
$network_scheme             = $resource['input']['network_scheme']

class {'l23network':
  ensure_package             => $ensure_package,
  use_lnx                    => $use_lnx,
  use_ovs                    => $use_ovs,
  install_ovs                => $install_ovs,
  install_brtool             => $install_brtool,
  install_ethtool            => $install_ethtool,
  install_bondtool           => $install_bondtool,
  install_vlantool           => $install_vlantool,
  ovs_modname                => $ovs_modname,
  ovs_datapath_package_name  => $ovs_datapath_package_name,
  ovs_common_package_name    => $ovs_common_package_name,
}

prepare_network_config($network_scheme)
$sdn = generate_network_config()
notify { $sdn: require => Class['l23network'], }

# We need to wait at least 30 seconds for the bridges and other interfaces to
# come up after being created.  This should allow for all interfaces to be up
# and ready for traffic before proceeding with further deploy steps. LP#1458954
exec { 'wait-for-interfaces':
  path    => '/usr/bin:/bin',
  command => 'sleep 32',
  require => Notify[$sdn]
}