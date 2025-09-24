notice('fuel-plugin-nsx-t: compute_nova_config.pp')

include ::nova::params

nova_config {
  'neutron/service_metadata_proxy': value => 'True';
  'neutron/ovs_bridge':             value => 'nsx-managed';
}

service { 'nova-compute':
  ensure     => running,
  name       => $::nova::params::compute_service_name,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
}

Nova_config<| |> ~> Service['nova-compute']
