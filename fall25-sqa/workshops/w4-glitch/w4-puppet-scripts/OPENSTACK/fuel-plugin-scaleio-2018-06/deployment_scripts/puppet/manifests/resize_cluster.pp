# The puppet sets 1_node mode and removes absent nodes if there are any ones.
# It expects that facters mdm_ips and tb_ips are correctly set to current cluster state


define cleanup_mdm () {
  $mdm_name = $title
  scaleio::mdm {"Remove MDM ${mdm_name}":
    ensure   => 'absent',
    sio_name => $mdm_name,
  }
}


notice('MODULAR: scaleio: resize_cluster')

# The only mdm with minimal IP from current MDMs does cleaunp
$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if ! $scaleio['existing_cluster'] {
    $all_nodes = hiera('nodes')
    $controller_ips_array = split($::controller_ips, ',')
    # names of mdm and tb are IPs in fuel
    $current_mdms = split($::managers_ips, ',')
    $current_tbs = split($::tb_ips, ',')
    $mdms_present = intersection($current_mdms, $controller_ips_array)
    $mdms_present_str = join($mdms_present, ',')
    $mdms_absent = difference($current_mdms, $mdms_present)
    $tbs_present = intersection($current_tbs, $controller_ips_array)
    $tbs_absent = difference($current_tbs, $tbs_present)
    $controllers_count = count($controller_ips_array)
    if $controllers_count < 3 {
      # 1 node mode
      $to_add_mdm_count = 1 - count($mdms_present)
      $to_add_tb_count = 0
    } else {
      # 3 node mode
      if $controllers_count < 5 {
        $to_add_mdm_count = 2 - count($mdms_present)
        $to_add_tb_count = 1 - count($tbs_present)
      } else {
        # 5 node mode
        $to_add_mdm_count = 3 - count($mdms_present)
        $to_add_tb_count = 2 - count($tbs_present)
      }
    }
    $nodes_present = concat(intersection($current_mdms, $controller_ips_array), $tbs_present)
    $available_nodes = difference($controller_ips_array, intersection($nodes_present, $controller_ips_array))
    if $to_add_tb_count > 0 and count($available_nodes) >= $to_add_tb_count {
      $last_tb_index = count($available_nodes) - 1
      $first_tb_index = $last_tb_index - $to_add_tb_count + 1
      $tbs_present_tmp = intersection($current_tbs, $controller_ips_array) # use tmp because concat modifys first param
      $new_tb_ips = join(concat($tbs_present_tmp, values_at($available_nodes, "${first_tb_index}-${last_tb_index}")), ',')
    } else {
      $new_tb_ips = join($tbs_present, ',')
    }
    if $to_add_mdm_count > 0 and count($available_nodes) >= $to_add_mdm_count {
      $last_mdm_index = $to_add_mdm_count - 1
      $mdms_present_tmp = intersection($current_mdms, $controller_ips_array) # use tmp because concat modifys first param
      $new_mdms_ips = join(concat($mdms_present_tmp, values_at($available_nodes, "0-${last_mdm_index}")), ',')
    } else {
      $new_mdms_ips = join($mdms_present, ',')
    }
    $is_primary_controller = !empty(filter_nodes(filter_nodes($all_nodes, 'name', $::hostname), 'role', 'primary-controller'))
    notify {"ScaleIO cluster: resize: controller_ips_array='${controller_ips_array}', current_mdms='${current_mdms}', current_tbs='${current_tbs}'": }
    if !empty($mdms_absent) or !empty($tbs_absent) {
      notify {"ScaleIO cluster: change: mdms_present='${mdms_present}', mdms_absent='${mdms_absent}', tbs_present='${tbs_present}', tbs_absent='${tbs_absent}'": }
      # primary-controller will do cleanup
      if $is_primary_controller {
        $active_mdms = split($::scaleio_mdm_ips, ',')
        $slaves_names = join(delete($active_mdms, $active_mdms[0]), ',')            # first is current master
        $to_remove_mdms = concat(split(join($mdms_absent, ','), ','), $tbs_absent)  # join/split because concat affects first argument
        scaleio::login {'Normal':
          password => $scaleio['password']
        } ->
        scaleio::cluster {'Resize cluster mode to 1_node and remove other MDMs':
          ensure       => 'absent',
          cluster_mode => 1,
          slave_names  => $slaves_names,
          tb_names     => $::scaleio_tb_ips,
          require      => Scaleio::Login['Normal'],
          before       => File_line['SCALEIO_mdm_ips']
        } ->
        cleanup_mdm {$to_remove_mdms:
          before              => File_line['SCALEIO_mdm_ips']
        }
      } else {
        notify {"ScaleIO cluster: resize: Not primary controller ${::hostname}": }
      }
    } else {
      notify {'ScaleIO cluster: resize: nothing to resize': }
    }
    file_line {'SCALEIO_mdm_ips':
      ensure => present,
      path   => '/etc/environment',
      match  => '^SCALEIO_mdm_ips=',
      line   => "SCALEIO_mdm_ips=${mdms_present_str}",
    } ->
    file_line {'SCALEIO_managers_ips':
      ensure => present,
      path   => '/etc/environment',
      match  => '^SCALEIO_managers_ips=',
      line   => "SCALEIO_managers_ips=${new_mdms_ips}",
    } ->
    file_line {'SCALEIO_tb_ips':
      ensure => present,
      path   => '/etc/environment',
      match  => '^SCALEIO_tb_ips=',
      line   => "SCALEIO_tb_ips=${new_tb_ips}",
    }
    # only primary-controller needs discovery of sds/sdc
    if $is_primary_controller {
      file_line {'SCALEIO_discovery_allowed':
        ensure  => present,
        path    => '/etc/environment',
        match   => '^SCALEIO_discovery_allowed=',
        line    => 'SCALEIO_discovery_allowed=yes',
        require => File_line['SCALEIO_tb_ips']
      }
    }
  } else {
    notify{'Skip configuring cluster because of using existing cluster': }
  }
}
