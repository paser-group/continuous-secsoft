# The puppet configures OpenStack nova to use ScaleIO.

notice('MODULAR: scaleio: nova')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  $all_nodes = hiera('nodes')
  $nodes = filter_nodes($all_nodes, 'name', $::hostname)
  if empty(filter_nodes($nodes, 'role', 'compute')) {
    fail("Compute Role is not found on the host ${::hostname}")
  }
  if $scaleio['provisioning_type'] and $scaleio['provisioning_type'] != '' {
    $provisioning_type = $scaleio['provisioning_type']
  } else {
    $provisioning_type = undef
  }
  $gateway_ip = $scaleio['existing_cluster'] ? {
    true => $scaleio['gateway_ip'],
    default => hiera('management_vip')
  }
  $password = $scaleio['password']
  if $scaleio['existing_cluster'] {
    $client_password = $password
  } else {
    $client_password_str = base64('encode', pw_hash($password, 'SHA-512', 'scaleio.client.access'))
    $client_password = inline_template('Sio-<%= @client_password_str[33..40] %>-<%= @client_password_str[41..48] %>')
  }
  if $::scaleio_sds_with_protection_domain_list and $::scaleio_sds_with_protection_domain_list != '' {
    $scaleio_sds_to_pd_map = hash(split($::scaleio_sds_with_protection_domain_list, ','))
  } else {
    $scaleio_sds_to_pd_map = {}
  }
  if $::hostname in $scaleio_sds_to_pd_map {
    $pd_name = $scaleio_sds_to_pd_map[$::hostname]
  } else {
    $pd_name = $scaleio['protection_domain']
  }
  class {'::scaleio_openstack::nova':
    ensure             => present,
    gateway_user       => $::gateway_user,
    gateway_password   => $client_password,
    gateway_ip         => $gateway_ip,
    gateway_port       => $::gateway_port,
    protection_domains => $pd_name,
    storage_pools      => $::storage_pools,
    provisioning_type  => $provisioning_type,
  }
}
