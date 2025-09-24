notice('fuel-plugin-nsx-t: reg-node-as-transport-node.pp')

include ::nsxt::params

$settings            = hiera($::nsxt::params::hiera_key)
$managers            = $settings['nsx_api_managers']
$user                = $settings['nsx_api_user']
$password            = $settings['nsx_api_password']
$uplink_profile_uuid = $settings['uplink_profile_uuid']
$transport_zone_uuid = $settings['default_overlay_tz_uuid']

if 'primary-controller' in hiera('roles') or 'controller' in hiera('roles') {
  $pnics               = $settings['controller_pnics_pairs']
  $static_ip_pool_uuid = $settings['controller_ip_pool_uuid']
} else {
  $pnics               = $settings['compute_pnics_pairs']
  $static_ip_pool_uuid = $settings['compute_ip_pool_uuid']
}

$vtep_interfaces = get_interfaces($pnics)
up_interface { $vtep_interfaces:
  before => Nsxt_create_transport_node['Add transport node'],
}

firewall {'0000 Accept STT traffic':
  proto  => 'tcp',
  dport  => ['7471'],
  action => 'accept',
  before => Nsxt_create_transport_node['Add transport node'],
}

if !$settings['insecure'] {
  $ca_filename = try_get_value($settings['ca_file'],'name','')
  if empty($ca_filename) {
    # default path to ca for Ubuntu 14.0.4
    $ca_file = '/etc/ssl/certs/ca-certificates.crt'
  } else {
    $ca_file = "${::nsxt::params::nsx_plugin_dir}/${ca_filename}"
  }
  Nsxt_create_transport_node { ca_file => $ca_file }
}

nsxt_create_transport_node { 'Add transport node':
  ensure            => present,
  managers          => $managers,
  username          => $user,
  password          => $password,
  uplink_profile_id => $uplink_profile_uuid,
  pnics             => $pnics,
  static_ip_pool_id => $static_ip_pool_uuid,
  transport_zone_id => $transport_zone_uuid,
}

# workaround, otherwise $title variable not work, always has a value 'main'
define up_interface {
  file { $title:
    ensure  => file,
    path    => "/etc/network/interfaces.d/ifcfg-${title}",
    mode    => '0644',
    content => "auto ${title}\niface ${title} inet manual",
    replace => true,
  } ->
  exec { $title:
    path     => '/usr/sbin:/usr/bin:/sbin:/bin',
    command  => "ifup ${title}",
    provider => 'shell',
  }
}
