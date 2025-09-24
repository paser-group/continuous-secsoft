#
# Configure the Datera driver in cinder
#
class cinder_datera_config::cinder (
    $backend_name  = 'datera',
    $backends      = ''
) {
    include cinder::params
    include cinder::client

    $plugin_settings = hiera('fuel-plugin-datera-cinder')

    if $::cinder::params::volume_package {
      package { $::cinder::params::volume_package:
        ensure => present,
      }
      Package[$::cinder::params::volume_package] -> Cinder_config<||>
    }

    if $plugin_settings['multibackend'] {
      $section = $backend_name
      cinder_config {
        'DEFAULT/enabled_backends': value => "${backend_name},${backends}";
      }
    } else {
      $section = 'DEFAULT'
    }

    cinder_datera_config::backend::datera{ $section :
      san_ip              => $plugin_settings['datera_mvip'],
      san_login           => $plugin_settings['datera_admin_login'],
      san_password        => $plugin_settings['datera_admin_password'],
      datera_num_replicas => $plugin_settings['datera_num_replicas'],
      extra_options       => {}
    }

    Cinder_config<||>~> Service[cinder_volume]

    service { 'cinder_volume':
      ensure     => running,
      name       => $::cinder::params::volume_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
    package { 'open-iscsi' :
      ensure => 'installed',
    }

}
