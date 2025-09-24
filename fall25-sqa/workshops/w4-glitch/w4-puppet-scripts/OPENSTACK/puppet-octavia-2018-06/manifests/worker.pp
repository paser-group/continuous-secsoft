# Installs & configure the octavia controller worker service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
# [*package_ensure*]
#   (optional) ensure state for package.
#   Defaults to 'present'
#
# [*amp_flavor_id*]
#   (optional) Nova instance flavor id for the Amphora.
#   Note: since we set manage_nova_flavor to True by default, we need
#   to set a valid amp_flavor_id by default, 65 was picked randomly.
#   Defaults to '65'.
#
# [*amp_image_tag*]
#   Glance image tag for Amphora image. Allows the Amphora image to be
#   referred to by a tag instead of an ID, allowing the Amphora image to
#   be updated without requiring reconfiguration of Octavia.
#   Defaults to $::os_service_default
#
# [*amp_secgroup_list*]
#   List of security groups to use for Amphorae.
#   Defaults to $::os_service_default
#
# [*amp_boot_network_list*]
#   List of networks to attach to Amphorae.
#   Defaults to []
#
# [*loadbalancer_topology*]
#   (optional) Load balancer topology configuration
#   Defaults to $::os_service_default
#
# [*manage_nova_flavor*]
#   (optional) Whether or not manage Nova flavor for the Amphora.
#   Defaults to true.
#
# [*nova_flavor_config*]
#   (optional) Nova flavor config hash.
#   Should be an hash.
#   Exemple:
#   $nova_flavor_config = { 'ram' => '2048' }
#   Possible options are documented in puppet-nova nova_flavor type.
#   Defaults to {}.
#
# [*amphora_driver*]
#   (optional) Name of driver for communicating with amphorae
#   Defaults to 'amphora_haproxy_rest_driver'
#
# [*compute_driver*]
#   (optional) Name of driver for managing amphorae VMs
#   Defaults to 'compute_nova_driver'
#
# [*network_driver*]
#   (optional) Name of network driver for configuring networking
#   for amphorae.
#   Defaults to 'allowed_address_pairs_driver' (neutron based)
#
# [*amp_ssh_key_name*]
#   (optional) Name of Openstack SSH keypair for communicating with amphora
#   Defaults to 'octavia-ssh-key'
#
# [*enable_ssh_access*]
#   (optional) Enable SSH key configuration for amphorae. Note that setting
#   to false disables configuration of SSH key related properties.
#   Defaults to true
#
# [*key_path*]
#   (optional) full path to the private key for the amphora SSH key
#   Defaults to '/etc/octavia/.ssh/octavia_ssh_key'
#
# [*manage_keygen*]
#   (optional) Whether or not create OpenStack keypair for communicating with amphora
#   Defaults to false
#
# [*amp_project_name*]
#   (optional) Set the project to be used for creating load balancer instances.
#   Defaults to undef
#
class octavia::worker (
  $manage_service        = true,
  $enabled               = true,
  $package_ensure        = 'present',
  $amp_flavor_id         = '65',
  $amp_image_tag         = $::os_service_default,
  $amp_secgroup_list     = $::os_service_default,
  $amp_boot_network_list = [],
  $loadbalancer_topology = $::os_service_default,
  $manage_nova_flavor    = true,
  $nova_flavor_config    = {},
  $amphora_driver        = 'amphora_haproxy_rest_driver',
  $compute_driver        = 'compute_nova_driver',
  $network_driver        = 'allowed_address_pairs_driver',
  $amp_ssh_key_name      = 'octavia-ssh-key',
  $enable_ssh_access     = true,
  $key_path              = '/etc/octavia/.ssh/octavia_ssh_key',
  $manage_keygen         = false,
  $amp_project_name      = undef
) inherits octavia::params {

  include ::octavia::deps

  validate_hash($nova_flavor_config)

  if ! is_service_default($loadbalancer_topology) and  ! ($loadbalancer_topology in ['SINGLE', 'ACTIVE_STANDBY']) {
      fail('load balancer topology must be one of SINGLE or ACTIVE_STANDBY')
  }

  if ! $amp_flavor_id {
    if $manage_nova_flavor {
      fail('When managing Nova flavor, octavia::worker::amp_flavor_id is required.')
    } else {
      warning('octavia::worker::amp_flavor_id is empty, Octavia Worker might not work correctly.')
    }
  } else {
    if $manage_nova_flavor {
      $octavia_flavor = { "octavia_${amp_flavor_id}" =>
        { 'id'      => $amp_flavor_id,
          'project' => $amp_project_name
        }
      }

      $octavia_flavor_defaults = {
        'ensure'    => 'present',
        'ram'       => '1024',
        'disk'      => '2',
        'vcpus'     => '1',
        'is_public' => false,
        'tag'       => ['octavia']
      }
      $nova_flavor_defaults = merge($octavia_flavor_defaults, $nova_flavor_config)
      create_resources('nova_flavor', $octavia_flavor, $nova_flavor_defaults)
      Nova_flavor<| tag == 'octavia' |> ~> Service['octavia-worker']
    }
  }

  package { 'octavia-worker':
    ensure => $package_ensure,
    name   => $::octavia::params::worker_package_name,
    tag    => ['openstack', 'octavia-package'],
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'octavia-worker':
    ensure     => $service_ensure,
    name       => $::octavia::params::worker_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['octavia-service'],
  }

  if $manage_keygen and ! $enable_ssh_access {
    fail('SSH key management cannot be enabled when SSH key access is disabled')
  }

  if $manage_keygen {
    exec {'create_amp_key_dir':
      path    => ['/bin', '/usr/bin'],
      command => "mkdir -p ${key_path}",
      creates => $key_path
    }

    file { 'amp_key_dir':
      ensure => directory,
      path   => $key_path,
      mode   => '0700',
      group  => 'octavia',
      owner  => 'octavia'
    }

    ssh_keygen { $amp_ssh_key_name:
      user     => 'octavia',
      type     => 'rsa',
      bits     => 2048,
      filename => "${key_path}/${amp_ssh_key_name}",
      comment  => 'Used for Octavia Service VM'
    }

    Package<| tag == 'octavia-package' |>
    -> Exec['create_amp_key_dir']
    -> File['amp_key_dir']
    -> Ssh_keygen[$amp_ssh_key_name]
  }

  if $enable_ssh_access {
    $ssh_key_name_real = $amp_ssh_key_name
    $key_path_real = $key_path
  }
  else {
    $ssh_key_name_real = $::os_service_default
    $key_path_real = $::os_service_default
  }

  octavia_config {
    'controller_worker/amp_flavor_id'         : value => $amp_flavor_id;
    'controller_worker/amp_image_tag'         : value => $amp_image_tag;
    'controller_worker/amp_secgroup_list'     : value => $amp_secgroup_list;
    'controller_worker/amp_boot_network_list' : value => $amp_boot_network_list;
    'controller_worker/loadbalancer_topology' : value => $loadbalancer_topology;
    'controller_worker/amphora_driver'        : value => $amphora_driver;
    'controller_worker/compute_driver'        : value => $compute_driver;
    'controller_worker/network_driver'        : value => $network_driver;
    'controller_worker/amp_ssh_key_name'      : value => $ssh_key_name_real;
    'haproxy_amphora/key_path'                : value => $key_path_real;
  }
}
