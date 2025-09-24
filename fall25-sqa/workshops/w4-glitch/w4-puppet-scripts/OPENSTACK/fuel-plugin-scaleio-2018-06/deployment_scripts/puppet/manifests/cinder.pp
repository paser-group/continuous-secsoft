# The puppet configures OpenStack cinder to use ScaleIO.

notice('MODULAR: scaleio: cinder')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  $all_nodes = hiera('nodes')
  $nodes = filter_nodes($all_nodes, 'name', $::hostname)
  if empty(filter_nodes($nodes, 'role', 'cinder')) {
    fail("Cinder Role is not found on the host ${::hostname}")
  }
  if $scaleio['provisioning_type'] and $scaleio['provisioning_type'] != '' {
    $provisioning_type = $scaleio['provisioning_type']
  } else {
    $provisioning_type = undef
  }
  $gateway_ip = $scaleio['existing_cluster'] ? {
    true  => $scaleio['gateway_ip'],
    default => hiera('management_vip')
  }
  $password = $scaleio['password']
  if $scaleio['existing_cluster'] {
    $client_password = $password
  } else {
    $client_password_str = base64('encode', pw_hash($password, 'SHA-512', 'scaleio.client.access'))
    $client_password = inline_template('Sio-<%= @client_password_str[33..40] %>-<%= @client_password_str[41..48] %>')
  }
  class {'::scaleio_openstack::cinder':
    ensure             => present,
    gateway_user       => $::gateway_user,
    gateway_password   => $client_password,
    gateway_ip         => $gateway_ip,
    gateway_port       => $::gateway_port,
    protection_domains => $scaleio['protection_domain'],
    storage_pools      => $::storage_pools,
    provisioning_type  => $provisioning_type,
  }
}
