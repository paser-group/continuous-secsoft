# The puppet configures OpenStack entities like flavor, volume_types, etc.

define apply_flavor(
  $flavors_hash = undef,    # hash of flavors
) {
  $resource_name = $title # 'flavor:action'
  $parsed_name = split($title, ':')
  $action = $parsed_name[1]
  if $action == 'add' {
    $flavor_name = $parsed_name[0]
    $flavor = $flavors_hash[$flavor_name]
    scaleio_openstack::flavor {$resource_name:
      ensure         => present,
      name           => $resource_name,
      storage_pool   => $flavor['storage_pool'],
      id             => $flavor['id'],
      ram_size       => $flavor['ram_size'],
      vcpus          => $flavor['vcpus'],
      disk_size      => $flavor['disk_size'],
      ephemeral_size => $flavor['ephemeral_size'],
      swap_size      => $flavor['swap_size'],
      rxtx_factor    => $flavor['rxtx_factor'],
      is_public      => $flavor['is_public'],
      provisioning   => $flavor['provisioning'],
    }
  } else {
    scaleio_openstack::flavor {$resource_name:
      ensure => absent,
      name   => $resource_name,
    }
  }
}

notice('MODULAR: scaleio: os')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  $all_nodes = hiera('nodes')
  if ! empty(filter_nodes(filter_nodes($all_nodes, 'name', $::hostname), 'role', 'primary-controller')) {
    if $scaleio['storage_pools'] and $scaleio['storage_pools'] != '' {
      # if storage pools come from settings remove probable trailing commas
      $pools_array = split($scaleio['storage_pools'], ',')
    } else {
      $pools_array = get_pools_from_sds_config($sds_devices_config)
    }
    $storage_pool = $pools_array ? {
      undef   => undef,
      default => $pools_array[0] # use first pool for flavors
    }
    $flavors = {
      'm1.micro' => {
        'id'              => undef,
        'ram_size'        => 64,
        'vcpus'           => 1,
        'disk_size'       => 8,         # because ScaleIO requires the size be multiplier of 8
        'ephemeral_size'  => 0,
        'rxtx_factor'     => 1,
        'is_public'       => 'True',
        'provisioning'    => 'thin',
        'storage_pool'    => $storage_pool,
      },
      'm1.tiny' => {
        'id'              => 1,
        'ram_size'        => 512,
        'vcpus'           => 1,
        'disk_size'       => 8,
        'ephemeral_size'  => 0,
        'rxtx_factor'     => 1,
        'is_public'       => 'True',
        'provisioning'    => 'thin',
        'storage_pool'    => $storage_pool,
      },
      'm1.small' => {
        'id'              => 2,
        'ram_size'        => 2048,
        'vcpus'           => 1,
        'disk_size'       => 24,
        'ephemeral_size'  => 0,
        'rxtx_factor'     => 1,
        'is_public'       => 'True',
        'provisioning'    => 'thin',
        'storage_pool'    => $storage_pool,
      },
      'm1.medium' => {
        'id'              => 3,
        'ram_size'        => 4096,
        'vcpus'           => 2,
        'disk_size'       => 48,
        'ephemeral_size'  => 0,
        'rxtx_factor'     => 1,
        'is_public'       => 'True',
        'provisioning'    => 'thin',
        'storage_pool'    => $storage_pool,
      },
      'm1.large' => {
        'id'              => 4,
        'ram_size'        => 8192,
        'vcpus'           => 4,
        'disk_size'       => 80,
        'ephemeral_size'  => 0,
        'rxtx_factor'     => 1,
        'is_public'       => 'True',
        'provisioning'    => 'thin',
        'storage_pool'    => $storage_pool,
      },
      'm1.xlarge' => {
        'id'              => 5,
        'ram_size'        => 16384,
        'vcpus'           => 8,
        'disk_size'       => 160,
        'ephemeral_size'  => 0,
        'rxtx_factor'     => 1,
        'is_public'       => 'True',
        'provisioning'    => 'thin',
        'storage_pool'    => $storage_pool,
      },
    }
    $to_remove_flavors = suffix(keys($flavors), ':remove')
    $to_add_flavors = suffix(keys($flavors), ':add')
    apply_flavor {$to_remove_flavors:
      flavors_hash => undef,
    } ->
    apply_flavor {$to_add_flavors:
      flavors_hash => $flavors,
    }
  }
}
