# == Class: magnum::certificates
#
# Manages the magnum certificate manager plugin
#
# === Parameters:
#
# [*cert_manager_type*]
#   (optional) Certificate Manager plugin. Defaults to barbican. (string value)
#   Defaults to 'barbican'
#
class magnum::certificates (
  $cert_manager_type = $::os_service_default,
) {

  include ::magnum::deps

  magnum_config { 'certificates/cert_manager_type':
    value => $cert_manager_type;
  }

}

