notice('fuel-plugin-nsx-t: neutron-server-stop.pp')

include ::neutron::params

service { 'neutron-server-stop':
  ensure     => 'stopped',
  name       => $::neutron::params::server_service,
}
