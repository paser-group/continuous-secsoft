notice('fuel-plugin-nsx-t: configure-agents-dhcp.pp')

neutron_dhcp_agent_config {
  'DEFAULT/ovs_integration_bridge':     value => 'nsx-managed';
  'DEFAULT/interface_driver':           value => 'neutron.agent.linux.interface.OVSInterfaceDriver';
  'DEFAULT/enable_metadata_network':    value => true;
  'DEFAULT/enable_isolated_metadata':   value => true;
  'DEFAULT/ovs_use_veth':               value => true;
}

if 'primary-controller' in hiera('roles') {
  exec { 'dhcp-agent-restart':
    command     => "crm resource restart $(crm status|awk '/dhcp/ {print \$3}')",
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    logoutput   => true,
    provider    => 'shell',
    tries       => 3,
    try_sleep   => 10,
  }
}
