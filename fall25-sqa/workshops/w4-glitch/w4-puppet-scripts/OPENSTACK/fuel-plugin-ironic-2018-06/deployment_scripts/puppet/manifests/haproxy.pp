notice('MODULAR: ironic/haproxy.pp')

$network_metadata   = hiera_hash('network_metadata')
$storage_hash       = hiera_hash('storage', {})
$public_ssl_hash    = hiera('public_ssl')

$ironic_api_nodes   = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
$ironic_address_map = get_node_to_ipaddr_map_by_network_role($ironic_api_nodes, 'ironic/api')
$ironic_server_names = hiera_array('ironic_names', keys($ironic_address_map))
$ironic_ipaddresses = hiera_array('ironic_ipaddresses', values($ironic_address_map))

$public_virtual_ip    = hiera('public_vip')
$internal_virtual_ip  = hiera('management_vip')
$baremetal_virtual_ip = $network_metadata['vips']['baremetal']['ipaddr']

if !($storage_hash['images_ceph'] and $storage_hash['objects_ceph']) and !$storage_hash['images_vcenter'] {
  $use_swift = true
} else {
  $use_swift = false
}
if !($use_swift) and ($storage_hash['objects_ceph']) {
  $use_radosgw = true
} else {
  $use_radosgw = false
}

Openstack::Ha::Haproxy_service {
  ipaddresses            => $ironic_ipaddresses,
  public_virtual_ip      => $public_virtual_ip,
  server_names           => $ironic_server_names,
  public                 => true,
  public_ssl             => $public_ssl_hash['services'],
  haproxy_config_options => {
    option => ['httpchk GET /', 'httplog','httpclose'],
  },
}

openstack::ha::haproxy_service { 'ironic-api':
  order               => '180',
  listen_port         => 6385,
  internal_virtual_ip => $internal_virtual_ip,
}

openstack::ha::haproxy_service { 'ironic-baremetal':
  order               => '185',
  listen_port         => 6385,
  public              => false,
  public_ssl          => false,
  public_virtual_ip   => false,
  internal_virtual_ip => $baremetal_virtual_ip,
}

if $use_swift {
  $swift_proxies_address_map = get_node_to_ipaddr_map_by_network_role(hiera_hash('swift_proxies', undef), 'swift/api')
  $swift_server_names        = hiera_array('swift_server_names', keys($swift_proxies_address_map))
  $swift_ipaddresses         = hiera_array('swift_ipaddresses', values($swift_proxies_address_map))

  openstack::ha::haproxy_service { 'swift-baremetal':
    order                  => '125',
    listen_port            => 8080,
    ipaddresses            => $swift_ipaddresses,
    server_names           => $swift_server_names,
    public                 => false,
    public_ssl             => false,
    public_virtual_ip      => false,
    internal_virtual_ip    => $baremetal_virtual_ip,
    haproxy_config_options => {
      'option' => ['httpchk', 'httplog', 'httpclose'],
    },
    balancermember_options => 'check port 49001 inter 15s fastinter 2s downinter 8s rise 3 fall 3',
  }
}

if $use_radosgw {
  $rgw_address_map     = get_node_to_ipaddr_map_by_network_role(hiera_hash('ceph_rgw_nodes'), 'ceph/radosgw')
  $rgw_server_names    = hiera_array('radosgw_server_names', keys($rgw_address_map))
  $rgw_ipaddresses     = hiera_array('radosgw_ipaddresses', values($rgw_address_map))

  openstack::ha::haproxy_service { 'radosgw-baremetal':
    order                  => '135',
    listen_port            => 8080,
    balancermember_port    => 6780,
    ipaddresses            => $rgw_ipaddresses,
    server_names           => $rgw_server_names,
    public                 => false,
    public_ssl             => false,
    public_virtual_ip      => false,
    internal_virtual_ip    => $baremetal_virtual_ip,
    haproxy_config_options => {
      'option' => ['httplog', 'httpchk GET /'],
    },
  }
}
