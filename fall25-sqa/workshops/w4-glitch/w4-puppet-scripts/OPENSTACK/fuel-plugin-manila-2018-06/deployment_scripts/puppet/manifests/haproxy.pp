notify {'MODULAR: fuel-plugin-manila/haproxy': }

$internal_virtual_ip = hiera('management_vip')
$ns                  = hiera_hash('network_scheme', {})
$br_mgmt             = split($ns['endpoints']['br-mgmt']['IP'][0], '/')
$ipaddresses         = $br_mgmt[0]
$public_virtual_ip   = hiera('public_vip')
# dirty hack.
$cinder_address_map  = get_node_to_ipaddr_map_by_network_role(hiera_hash('cinder_nodes'), 'cinder/api')
$server_names        = hiera_array('cinder_names', keys($cinder_address_map))
#
$ssl_hash           = hiera_hash('use_ssl', {})
$public_ssl_hash    = hiera_hash('public_ssl', {})
$public_ssl         = get_ssl_property($ssl_hash, $public_ssl_hash, 'manila', 'public', 'usage', false)
$public_ssl_path    = get_ssl_property($ssl_hash, $public_ssl_hash, 'manila', 'public', 'path', [''])

$internal_ssl       = get_ssl_property($ssl_hash, {}, 'manila', 'internal', 'usage', false)
$internal_ssl_path  = get_ssl_property($ssl_hash, {}, 'manila', 'internal', 'path', [''])


class { '::manila_auxiliary::haproxy':
  internal_virtual_ip => $internal_virtual_ip,
  ipaddresses         => $ipaddresses,
  public_virtual_ip   => $public_virtual_ip,
  server_names        => $server_names,
  public_ssl          => $public_ssl,
  public_ssl_path     => $public_ssl_path,
  internal_ssl        => $internal_ssl,
  internal_ssl_path   => $internal_ssl_path,
}
