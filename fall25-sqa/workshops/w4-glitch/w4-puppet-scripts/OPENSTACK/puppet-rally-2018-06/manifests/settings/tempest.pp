# == Class: rally::settings::tempest
#
# Configure Rally benchmarking settings
#
# === Parameters
#
# [*img_url*]
#   (Optional) image URL.
#   Defaults to $::os_service_default
#
# [*img_disk_format*]
#   (Optional) Image disk format to use when creating the image.
#   Defaults to $::os_service_default
#
# [*img_container_format*]
#   (Optional) Image container format to use when creating the image.
#   Defaults to $::os_service_default
#
# [*img_name_regex*]
#   (Optional) Regular expression for name of a public image to discover it in the cloud and use it for the tests.
#   Defaults to $::os_service_default
#
# [*swift_operator_role*]
#   (Optional) Role required for users to be able to create Swift containers.
#   Defaults to $::os_service_default
#
# [*swift_reseller_admin_role*]
#   (Optional) User role that has reseller admin.
#   Defaults to $::os_service_default
#
# [*heat_stack_owner_role*]
#   (Optional) Role required for users to be able to manage Heat stacks.
#   Defaults to $::os_service_default
#
# [*heat_stack_user_role*]
#   (Optional) Role for Heat template-defined users.
#   Defaults to $::os_service_default
#
# [*flavor_ref_ram*]
#   (Optional) Primary flavor RAM size used by most of the test cases.
#   Defaults to $::os_service_default
#
# [*flavor_ref_alt_ram*]
#   (Optional) Alternate reference flavor RAM size used by test thatneed two
#   flavors, like those that resize an instnace.
#   Defaults to $::os_service_default
#
# [*heat_instance_type_ram*]
#   (Optional) RAM size flavor used for orchestration test cases.
#   Defaults to $::os_service_default
#
class rally::settings::tempest (
  $img_url                   = $::os_service_default,
  $img_disk_format           = $::os_service_default,
  $img_container_format      = $::os_service_default,
  $img_name_regex            = $::os_service_default,
  $swift_operator_role       = $::os_service_default,
  $swift_reseller_admin_role = $::os_service_default,
  $heat_stack_owner_role     = $::os_service_default,
  $heat_stack_user_role      = $::os_service_default,
  $flavor_ref_ram            = $::os_service_default,
  $flavor_ref_alt_ram        = $::os_service_default,
  $heat_instance_type_ram    = $::os_service_default
) {

  include ::rally::deps

  rally_config {
    'tempest/img_url':                   value => $img_url;
    'tempest/img_disk_format':           value => $img_disk_format;
    'tempest/img_container_format':      value => $img_container_format;
    'tempest/img_name_regex':            value => $img_name_regex;
    'tempest/swift_operator_role':       value => $swift_operator_role;
    'tempest/swift_reseller_admin_role': value => $swift_reseller_admin_role;
    'tempest/heat_stack_owner_role':     value => $heat_stack_owner_role;
    'tempest/heat_stack_user_role':      value => $heat_stack_user_role;
    'tempest/flavor_ref_ram':            value => $flavor_ref_ram;
    'tempest/flavor_ref_alt_ram':        value => $flavor_ref_alt_ram;
    'tempest/heat_instance_type_ram':    value => $heat_instance_type_ram;
  }
}
