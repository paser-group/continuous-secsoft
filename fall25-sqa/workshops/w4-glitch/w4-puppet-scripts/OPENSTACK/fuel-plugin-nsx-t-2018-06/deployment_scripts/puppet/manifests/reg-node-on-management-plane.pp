notice('fuel-plugin-nsx-t: reg-node-on-management-plane.pp')

include ::nsxt::params

$settings     = hiera($::nsxt::params::hiera_key)
$managers     = $settings['nsx_api_managers']
$user         = $settings['nsx_api_user']
$password     = $settings['nsx_api_password']

nsxt_add_to_fabric { 'Register controller node on management plane':
  ensure   => present,
  managers => $managers,
  username => $user,
  password => $password,
}

if !$settings['insecure'] {
  $ca_filename = try_get_value($settings['ca_file'],'name','')
  if empty($ca_filename) {
    # default path to ca for Ubuntu 14.0.4
    $ca_file = '/etc/ssl/certs/ca-certificates.crt'
  } else {
    $ca_file = "${::nsxt::params::nsx_plugin_dir}/${ca_filename}"
  }
  Nsxt_add_to_fabric { ca_file => $ca_file }
}

service { 'openvswitch-switch':
  ensure => 'running'
}

Nsxt_add_to_fabric<||> -> Service['openvswitch-switch']
