notice('MODULAR: ironic/ironic-conductor-config.pp')

$ironic_hash                = hiera_hash('fuel-plugin-ironic', {})
$management_vip             = hiera('management_vip')
$keystone_endpoint          = hiera('keystone_endpoint', $management_vip)

$ironic_tenant              = pick($ironic_hash['tenant'],'services')
$ironic_user                = pick($ironic_hash['user'],'ironic')
$ironic_user_password       = pick($ironic_hash['password'],'ironic')

include ::ironic::params

ironic_images_setter {'ironic_images':
  ensure           => present,
  auth_url         => "http://${keystone_endpoint}:5000/v2.0/",
  auth_username    => $ironic_user,
  auth_password    => $ironic_user_password,
  auth_tenant_name => $ironic_tenant,
  glance_url       => "http://${management_vip}:9292/v2.0/",
}

service { 'ironic-conductor':
  ensure    => 'running',
  name      => $::ironic::params::conductor_service,
  enable    => true,
  hasstatus => true,
  tag       => 'ironic-service',
}

Ironic_images_setter<||> ~> Service['ironic-conductor']
