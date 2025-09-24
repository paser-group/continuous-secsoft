notify {'MODULAR fuel-plugin-manila/keystone': }

$manila            = hiera_hash('manila', {})
$pass              = $manila['user_password']

$public_ssl_hash   = hiera_hash('public_ssl')
$ssl_hash          = hiera_hash('use_ssl', {})
$public_vip        = hiera('public_vip')
$management_vip    = hiera('management_vip')

$public_protocol   = get_ssl_property($ssl_hash, $public_ssl_hash, 'manila', 'public', 'protocol', 'http')
$public_address    = get_ssl_property($ssl_hash, $public_ssl_hash, 'manila', 'public', 'hostname', [$public_vip])
$internal_protocol = get_ssl_property($ssl_hash, {}, 'manila', 'internal', 'protocol', 'http')
$internal_address  = get_ssl_property($ssl_hash, {}, 'manila', 'internal', 'hostname', [$management_vip])
$admin_protocol    = get_ssl_property($ssl_hash, {}, 'manila', 'admin', 'protocol', 'http')
$admin_address     = get_ssl_property($ssl_hash, {}, 'manila', 'admin', 'hostname', [$management_vip])
$port              = '8786'

$public_base_url   = "${public_protocol}://${public_address}:${port}"
$internal_base_url = "${internal_protocol}://${internal_address}:${port}"
$admin_base_url    = "${admin_protocol}://${admin_address}:${port}"

class {'::manila::keystone::auth':
  password        => $pass,
  public_url      => "${public_base_url}/v1/%(tenant_id)s",
  public_url_v2   => "${public_base_url}/v2/%(tenant_id)s",
  admin_url       => "${admin_base_url}/v1/%(tenant_id)s",
  admin_url_v2    => "${admin_base_url}/v2/%(tenant_id)s",
  internal_url    => "${internal_base_url}/v1/%(tenant_id)s",
  internal_url_v2 => "${internal_base_url}/v2/%(tenant_id)s",
}
