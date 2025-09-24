# The puppet reset mdm ips into initial state for next cluster detection on controllers.
# On client nodes just all controllers are used as mdm ips because no way to detect cluster there.

define env_fact($role, $fact, $value) {
  file_line { "Append a SCALEIO_${role}_${fact} line to /etc/environment":
    ensure => present,
    path   => '/etc/environment',
    match  => "^SCALEIO_${role}_${fact}=",
    line   => "SCALEIO_${role}_${fact}=${value}",
  }
}

notice('MODULAR: scaleio: environment')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  notify{'ScaleIO plugin enabled': }
  # The following exec allows interrupt for debugging at the very beginning of the plugin deployment
  # because Fuel doesn't provide any tools for this and deployment can last for more than two hours.
  # Timeouts in tasks.yaml and in the deployment_tasks.yaml (which in 6.1 is not user-exposed and
  # can be found for example in astute docker container during deloyment) should be set to high values.
  # It'll be invoked only if /tmp/scaleio_debug file exists on particular node and you can use 
  # "touch /tmp/go" when you're ready to resume.
  exec { 'Wait on debug interrupt: use touch /tmp/go to resume':
    command => "bash -c 'while [ ! -f /tmp/go ]; do :; done'",
    path    => [ '/bin/' ],
    onlyif  => 'ls /tmp/scaleio_debug',
  }
  case $::osfamily {
    'RedHat': {
      fail('This is a temporary limitation. ScaleIO supports only Ubuntu for now.')
    }
    'Debian': {
      # nothing to do
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
    }
  }
  $all_nodes = hiera('nodes')
  if ! $scaleio['skip_checks'] and empty(filter_nodes($all_nodes, 'role', 'cinder')) {
    fail('At least one Node with Cinder role is required')
  }
  if $scaleio['existing_cluster'] {
    # Existing ScaleIO cluster attaching
    notify{'Use existing ScaleIO cluster': }
    env_fact{"Environment fact: role gateway, ips: ${scaleio['gateway_ip']}":
      role  => 'gateway',
      fact  => 'ips',
      value => $scaleio['gateway_ip']
    } ->
    env_fact{"Environment fact: role gateway, user: ${scaleio['gateway_user']}":
      role  => 'gateway',
      fact  => 'user',
      value => $scaleio['gateway_user']
    } ->
    env_fact{"Environment fact: role gateway, password: ${scaleio['password']}":
      role  => 'gateway',
      fact  => 'password',
      value => $scaleio['password']
    } ->
    env_fact{"Environment fact: role gateway, port: ${scaleio['gateway_port']}":
      role  => 'gateway',
      fact  => 'port',
      value => $scaleio['gateway_port']
    } ->
    env_fact{"Environment fact: role storage, pools: ${scaleio['existing_storage_pools']}":
      role  => 'storage',
      fact  => 'pools',
      value => $scaleio['existing_storage_pools']
    }
    # mdm_ips are requested from gateways in separate manifest because no way to pass args to facter
  }
  else {
    # New ScaleIO cluster deployment
    notify{'Deploy ScaleIO cluster': }
    $controllers_nodes = filter_nodes($all_nodes, 'role', 'controller')
    $primary_controller_nodes = filter_nodes($all_nodes, 'role', 'primary-controller')
    #use management network for ScaleIO components communications
    # order of ips should be equal on all nodes:
    #   - first ip must be primary controller, others should be sorted have defined order
    $controllers_ips_ = ipsort(values(nodes_to_hash($controllers_nodes, 'name', 'internal_address')))
    $controller_ips_array = concat(values(nodes_to_hash($primary_controller_nodes, 'name', 'internal_address')), $controllers_ips_)
    $ctrl_ips = join($controller_ips_array, ',')
    notify{"ScaleIO cluster: ctrl_ips=${ctrl_ips}": }
    # Check SDS count
    $use_plugin_roles = $scaleio['enable_sds_role']
    if ! $use_plugin_roles {
      if $scaleio['hyper_converged_deployment'] {
        $controller_sds_count = $scaleio['sds_on_controller'] ? {
          true    => count($controller_ips_array),
          default => 0
        }
        $total_sds_count = count(filter_nodes($all_nodes, 'role', 'compute')) + $controller_sds_count
      } else {
        $total_sds_count = count(filter_nodes($all_nodes, 'role', 'scaleio'))
      }
      if $total_sds_count < 3 {
        $sds_check_msg = 'There should be at least 3 nodes with SDSs, either add Compute node or use Controllers as SDS.'
      }
    } else {
      $tier1_sds_count = count(filter_nodes($all_nodes, 'role', 'scaleio-storage-tier1'))
      $tier2_sds_count = count(filter_nodes($all_nodes, 'role', 'scaleio-storage-tier2'))
      if $tier1_sds_count != 0 and $tier1_sds_count < 3 {
        $sds_check_msg = 'There are less than 3 nodes with Scaleio Storage Tier1 role.'
      }
      if $tier2_sds_count != 0 and $tier2_sds_count < 3 {
        $sds_check_msg = 'There are less than 3 nodes with Scaleio Storage Tier2 role.'
      }
    }
    if $sds_check_msg {
      if ! $scaleio['skip_checks'] {
        fail($sds_check_msg)
      } else{
        warning($sds_check_msg)
      }
    }
    $nodes = filter_nodes($all_nodes, 'name', $::hostname)
    if ! empty(concat(filter_nodes($nodes, 'role', 'controller'), filter_nodes($nodes, 'role', 'primary-controller'))) {
      if $::memorysize_mb < 2900 {
        if ! $scaleio['skip_checks'] {
          fail("Controller node requires at least 3000MB but there is ${::memorysize_mb}")
        } else {
          warning("Controller node requires at least 3000MB but there is ${::memorysize_mb}")
        }
      }
    }
    if $::sds_storage_small_devices {
      if ! $scaleio['skip_checks'] {
        fail("Storage devices minimal size is 100GB. The following devices do not meet this requirement ${::sds_storage_small_devices}")
      } else {
        warning("Storage devices minimal size is 100GB. The following devices do not meet this requirement ${::sds_storage_small_devices}")
      }
    }
    # mdm ips  and tb ips must be emtpy to avoid queries from ScaleIO about SDC/SDS,
    # the next task (cluster discovering) will set them into correct values.
    env_fact{'Environment fact: mdm ips':
      role  => 'mdm',
      fact  => 'ips',
      value => ''
    } ->
      env_fact{'Environment fact: managers ips':
        role  => 'managers',
        fact  => 'ips',
        value => ''
      } ->
    env_fact{'Environment fact: tb ips':
      role  => 'tb',
      fact  => 'ips',
      value => ''
    } ->
    env_fact{'Environment fact: gateway ips':
      role  => 'gateway',
      fact  => 'ips',
      value => $ctrl_ips
    } ->
    env_fact{'Environment fact: controller ips':
      role  => 'controller',
      fact  => 'ips',
      value => $ctrl_ips
    } ->
    env_fact{'Environment fact: role gateway, user: scaleio_client':
      role  => 'gateway',
      fact  => 'user',
      value => 'scaleio_client'
    } ->
    env_fact{'Environment fact: role gateway, port: 4443':
      role  => 'gateway',
      fact  => 'port',
      value => 4443
    } ->
    env_fact{"Environment fact: role storage, pools: ${scaleio['storage_pools']}":
      role  => 'storage',
      fact  => 'pools',
      value => $scaleio['storage_pools']
    }
  }
} else {
    notify{'ScaleIO plugin disabled': }
}
