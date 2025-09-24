# == Class: rally::settings::swift
#
# Configure Rally benchmarking settings
#
# === Parameters
#
# [*operator_role*]
#   (Optional) Role required for users to be able to create Swift containers
#   Defaults to $::os_service_default
#
# [*reseller_admin_role*]
#   (Optional) User role that has reseller admin
#   Defaults to $::os_service_default
#
class rally::settings::swift (
  $operator_role       = $::os_service_default,
  $reseller_admin_role = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'role/swift_operator_role':       value => $operator_role;
    'role/swift_reseller_admin_role': value => $reseller_admin_role;
  }
}
