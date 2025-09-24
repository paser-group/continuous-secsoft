class platform::deviceimage::params(
  $source_deviceimage_base_dir = '/opt/platform/device_images',
  $target_deviceimage_base_dir = '/www/pages/device_images',
) {}

class platform::deviceimage
  inherits ::platform::deviceimage::params {

    file {$target_deviceimage_base_dir:
      ensure  => directory,
      owner   => 'www',
      require => User['www']
    }

    Drbd::Resource <| |>

    -> file {$source_deviceimage_base_dir:
      ensure  => directory,
      owner   => 'www',
      require => User['www']
    }

  }
