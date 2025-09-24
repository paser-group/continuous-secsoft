# == Class: cinder_datera_config::volume::datera
#
# Configures Cinder volume Datera driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use Datera volume driver.
#   Defaults to 'cinder.volume.drivers.datera.DateraDriver'
#
# [*san_ip*]
#   (required) IP address of Datera clusters MVIP.
#
# [*san_login*]
#   (required) Username for Datera admin account.
#
# [*san_password*]
#   (required) Password for Datera admin account.
#
# [*datera_num_replicas*]
#   (optional) Number of replicas to keep.
#   Defaults to 2
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the cinder.conf
#   Defaults to: {}
#   Example :
#     { 'datera_backend/param1' => { 'value' => value1 } }
#
class cinder_datera_config::volume::datera(
  $san_ip,
  $san_login,
  $san_password,
  $volume_driver       = 'cinder.volume.drivers.datera.DateraDriver',
  $datera_num_replicas= '2',
  $extra_options       = {},
) {

  cinder::backend::datera { 'DEFAULT':
    san_ip              => $san_ip,
    san_login           => $san_login,
    san_password        => $san_password,
    volume_driver       => $volume_driver,
    datera_num_replicas => $datera_num_replicas,
    extra_options       => $extra_options,
  }
}
