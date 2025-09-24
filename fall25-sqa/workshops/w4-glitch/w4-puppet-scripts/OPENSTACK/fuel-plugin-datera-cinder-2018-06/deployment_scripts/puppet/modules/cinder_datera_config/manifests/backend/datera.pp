# == Class: cinder_datera_config::backend::datera
#
# Configures Cinder volume Datera driver.
# Parameters are particular to each volume driver.
#
# === Parameters
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*volume_driver*]
#   (optional) Setup cinder-volume to use Datera volume driver.
#   Defaults to 'cinder.volume.drivers.datera.DateraDriver'
#
# [*san_ip*]
#   (required) IP address of Datera clusters MVIP.
#
# [*san_login*]
#   (required) Username for Datera tenant admin account.
#
# [*san_password*]
#   (required) Password for Datera tenant admin account.
#
# [*datera_num_replicas*]
#   (optional) The number of replicas to keep.
#   Defaults to 2
#
# [*extra_options*]
#   (optional) Hash of extra options to pass to the cinder.conf
#   Defaults to: {}
#   Example :
#     { 'datera_backend/param1' => { 'value' => value1 } }
#
define cinder_datera_config::backend::datera(
  $san_ip,
  $san_login,
  $san_password,
  $datera_num_replicas,
  $volume_backend_name = $name,
  $volume_driver       = 'cinder.volume.drivers.datera.DateraDriver',
  $extra_options       = {},
) {

  cinder_config {
    "${name}/volume_backend_name": value => $volume_backend_name;
    "${name}/volume_driver":       value => $volume_driver;
    "${name}/san_ip":              value => $san_ip;
    "${name}/san_login":           value => $san_login;
    "${name}/san_password":        value => $san_password, secret => true;
    "${name}/datera_num_replicas": value => $datera_num_replicas;
  }

  create_resources('cinder_config', $extra_options)

}
