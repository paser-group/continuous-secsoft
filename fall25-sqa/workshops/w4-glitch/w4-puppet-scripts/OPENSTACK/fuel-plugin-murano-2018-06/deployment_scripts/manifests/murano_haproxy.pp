notice('MURANO PLUGIN: murano_haproxy.pp')

$murano_hash        = hiera_hash('murano_plugin',{})
$murano_cfapi_hash  = hiera_hash('murano_cfapi_plugin', {})
$public_ssl_hash    = hiera_hash('public_ssl', {})
$ssl_hash           = hiera_hash('use_ssl', {})
$external_lb        = hiera('external_lb', false)

if (!$external_lb) {
  $public_ssl        = get_ssl_property($ssl_hash, $public_ssl_hash, 'murano', 'public', 'usage', false)
  $public_ssl_path   = get_ssl_property($ssl_hash, $public_ssl_hash, 'murano', 'public', 'path', [''])
  $internal_ssl      = get_ssl_property($ssl_hash, {}, 'murano', 'internal', 'usage', false)
  $internal_ssl_path = get_ssl_property($ssl_hash, {}, 'murano', 'internal', 'path', [''])

  $server_names        = $murano_hash['murano_nodes']
  $ipaddresses         = $murano_hash['murano_ipaddresses']
  $murano_cfapi        = pick($murano_cfapi_hash['enabled'], false)
  $public_virtual_ip   = hiera('public_vip')
  $internal_virtual_ip = hiera('management_vip')

  Openstack::Ha::Haproxy_service {
    internal_virtual_ip => $internal_virtual_ip,
    ipaddresses         => $ipaddresses,
    public_virtual_ip   => $public_virtual_ip,
    server_names        => $server_names,
    public              => true,
  }

  openstack::ha::haproxy_service { 'murano-api':
    order                  => '190',
    listen_port            => 8082,
    public_ssl             => $public_ssl,
    public_ssl_path        => $public_ssl_path,
    internal_ssl           => $internal_ssl,
    internal_ssl_path      => $internal_ssl_path,
    require_service        => 'murano_api',
    haproxy_config_options => {
      'http-request' => 'set-header X-Forwarded-Proto https if { ssl_fc }',
    },
  }

  if $murano_cfapi {
    openstack::ha::haproxy_service { 'murano-cfapi':
      order                  => '192',
      listen_port            => 8083,
      public_ssl             => $public_ssl,
      public_ssl_path        => $public_ssl_path,
      internal_ssl           => $internal_ssl,
      internal_ssl_path      => $internal_ssl_path,
      require_service        => 'murano_cfapi',
      haproxy_config_options => {
        'http-request' => 'set-header X-Forwarded-Proto https if { ssl_fc }',
      },
    }
  }

  openstack::ha::haproxy_service { 'murano_rabbitmq':
    order                  => '191',
    listen_port            => 55572,
    define_backups         => true,
    internal               => false,
    haproxy_config_options => {
      'option'         => ['tcpka'],
      'timeout client' => '48h',
      'timeout server' => '48h',
      'balance'        => 'roundrobin',
      'mode'           => 'tcp'
    },
    balancermember_options => 'check inter 5000 rise 2 fall 3',
  }
}
