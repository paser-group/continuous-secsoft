# The puppet discovers cluster and updates mdm_ips and tb_ips values for next cluster task.

notice('MODULAR: scaleio: discovery_cluster')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if ! $scaleio['existing_cluster'] {
    # names of mdm and tb are IPs in fuel
    $current_mdms = split($::scaleio_mdm_ips, ',')
    $current_managers = concat(split($::scaleio_mdm_ips, ','), split($::scaleio_standby_mdm_ips, ','))
    $current_tbs = concat(split($::scaleio_tb_ips, ','), split($::scaleio_standby_tb_ips, ','))
    $discovered_mdms_ips = join($current_mdms, ',')
    $discovered_managers_ips = join($current_managers, ',')
    $discovered_tbs_ips = join($current_tbs, ',')
    notify {"ScaleIO cluster: discovery: discovered_managers_ips='${discovered_managers_ips}', discovered_tbs_ips='${discovered_tbs_ips}'": } ->
    file_line {'SCALEIO_mdm_ips':
      ensure => present,
      path   => '/etc/environment',
      match  => '^SCALEIO_mdm_ips=',
      line   => "SCALEIO_mdm_ips=${discovered_mdms_ips}",
    } ->
    file_line {'SCALEIO_managers_ips':
      ensure => present,
      path   => '/etc/environment',
      match  => '^SCALEIO_managers_ips=',
      line   => "SCALEIO_managers_ips=${discovered_managers_ips}",
    } ->
    file_line {'SCALEIO_tb_ips':
      ensure => present,
      path   => '/etc/environment',
      match  => '^SCALEIO_tb_ips=',
      line   => "SCALEIO_tb_ips=${discovered_tbs_ips}",
    }
  } else {
    notify{'Skip configuring cluster because of using existing cluster': }
  }
}
