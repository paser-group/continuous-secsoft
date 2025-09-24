# The puppet installs ScaleIO MDM packages.

notice('MODULAR: scaleio: mdm_server')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if ! $scaleio['existing_cluster'] {
    $all_nodes = hiera('nodes')
    $node_ips = split($::ip_address_array, ',')
    $new_mdm_ips = split($::managers_ips, ',')
    $is_tb = ! empty(intersection(split($::tb_ips, ','), $node_ips))
    $is_mdm = ! empty(intersection($new_mdm_ips, $node_ips))
    if $is_tb or $is_mdm {
      if $is_tb {
        $is_manager = 0
        $master_mdm_name = undef
        $master_ip = undef
      } else {
        $is_manager = 1
        $is_new_cluster = ! $::scaleio_mdm_ips or $::scaleio_mdm_ips == ''
        $is_primary_controller = ! empty(filter_nodes(filter_nodes($all_nodes, 'name', $::hostname), 'role', 'primary-controller'))
        if $is_new_cluster and $is_primary_controller {
          $master_ip = $new_mdm_ips[0]
          $master_mdm_name = $new_mdm_ips[0]
        } else {
          $master_ip = undef
          $master_mdm_name = undef
        }
      }
      $old_password = $::mdm_password ? {
        undef   => 'admin',
        default => $::mdm_password
      }
      $password = $scaleio['password']
      notify {"Controller server is_manager=${is_manager} master_mdm_name=${master_mdm_name} master_ip=${master_ip}": } ->
      class {'::scaleio::mdm_server':
        ensure          => 'present',
        is_manager      => $is_manager,
        master_mdm_name => $master_mdm_name,
        mdm_ips         => $master_ip,
      }
      if $old_password != $password {
        if $master_mdm_name {
          scaleio::login {'First':
            password => $old_password,
            require  => Class['scaleio::mdm_server']
          } ->
          scaleio::cluster {'Set password':
            password     => $old_password,
            new_password => $password,
            before       => File_line['Append a SCALEIO_mdm_password line to /etc/environment']
          }
        }
        file_line {'Append a SCALEIO_mdm_password line to /etc/environment':
          ensure => present,
          path   => '/etc/environment',
          match  => '^SCALEIO_mdm_password=',
          line   => "SCALEIO_mdm_password=${password}",
        }
      }
    } else {
      notify{'Skip deploying mdm server because it is not mdm and tb': }
    }
  } else {
    notify{'Skip deploying mdm server because of using existing cluster': }
  }
}

