class nsxt::hiera_override (
  $override_file_name,
) {
  $override_file_path = "/etc/hiera/plugins/${override_file_name}.yaml"
  hiera_overrides($override_file_path)
}
