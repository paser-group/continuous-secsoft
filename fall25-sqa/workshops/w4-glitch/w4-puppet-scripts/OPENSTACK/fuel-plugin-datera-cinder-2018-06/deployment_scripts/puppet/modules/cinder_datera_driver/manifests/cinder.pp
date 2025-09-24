
notice('PLUGIN: cinder_datera_driver::cinder: cinder.pp')

#
# Installs the Datera cinder driver
#
class cinder_datera_driver::cinder {
    $version = hiera('fuel_version')
    $file = '/usr/lib/python2.7/dist-packages/cinder/volume/drivers/datera.py'
    # install the driver, only required on cinder nodes
    notice("PLUGIN: cinder_datera_driver::cinder: trying to install Fuel \
      ${version} plugin.")
    if($version == '7.0') {
        file { $file:
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/cinder_datera_driver/7.0/datera.py',
        }
    } elsif ($version == '8.0') {
        file { $file:
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/cinder_datera_driver/8.0/datera.py',
        }
    } else {
        notice("PLUGIN: cinder_datera_driver::cinder: ${version} is not \
          supported by us.")
    }
}
class { 'cinder_datera_driver::cinder': }
