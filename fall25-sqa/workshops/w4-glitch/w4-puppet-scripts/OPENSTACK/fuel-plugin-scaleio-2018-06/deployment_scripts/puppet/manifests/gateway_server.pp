# The puppet configures ScaleIO Gateway. Sets the password and connects to MDMs.

notice('MODULAR: scaleio: gateway_server')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if ! $scaleio['existing_cluster'] {
    if $::managers_ips {
      $gw_ips = split($::gateway_ips, ',')
      $haproxy_config_options = {
          'balance' => 'roundrobin',
          'mode'    => 'tcp',
          'option'  => ['tcplog'],
      }
      Haproxy::Service        { use_include => true }
      Haproxy::Balancermember { use_include => true }
      class {'::scaleio::gateway_server':
        ensure   => 'present',
        mdm_ips  => $::managers_ips,
        password => $scaleio['password'],
        pkg_ftp => $scaleio['pkg_ftp'],
      } ->
      notify { "Configure Haproxy for Gateway nodes: ${gw_ips}": } ->
      openstack::ha::haproxy_service { 'scaleio-gateway':
        order                  => 201,
        server_names           => $gw_ips,
        ipaddresses            => $gw_ips,
        listen_port            => $::gateway_port,
        public_virtual_ip      => hiera('public_vip'),
        internal_virtual_ip    => hiera('management_vip'),
        define_backups         => true,
        public                 => true,
        haproxy_config_options => $haproxy_config_options,
        balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
      }
    } else {
      fail('Empty MDM IPs configuration')
    }
  } else {
    notify{'Skip deploying gateway server because of using existing cluster': }
  }

}
