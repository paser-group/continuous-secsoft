notice('MURANO PLUGIN: murano_hiera_override.pp')

$murano_plugin = hiera('detach-murano', undef)
$hiera_dir = '/etc/hiera/plugins'
$plugin_name = 'detach-murano'
$plugin_yaml = "${plugin_name}.yaml"

if $murano_plugin {
  $additional_settings = parseyaml($murano_plugin['yaml_additional_config']) # stdlib 4.9.x tag in mitaka supports only 1 argument
  if is_bool($additional_settings) {
    $settings_hash = {}
  } else {
    $settings_hash = $additional_settings
  }
  $network_metadata   = hiera_hash('network_metadata')
  $murano_base_hash   = hiera_hash('murano', {})
  $murano_role_exists = empty(nodes_with_roles(['primary-murano-node'])) ? {
    true    => false,
    default => true,
  }
  if $murano_role_exists {
    $murano_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-murano-node', 'murano-node'])
    $murano_address_map = get_node_to_ipaddr_map_by_network_role($murano_nodes, 'management')
    $murano_nodes_ips   = values($murano_address_map)
    $murano_nodes_names = keys($murano_address_map)
  } else {
    $murano_nodes       = get_nodes_hash_by_roles($network_metadata, ['primary-controller', 'controller'])
    $murano_address_map = get_node_to_ipaddr_map_by_network_role($murano_nodes, 'management')
    $murano_nodes_ips   = values($murano_address_map)
    $murano_nodes_names = keys($murano_address_map)
  }
  $murano_db_password     = pick($settings_hash['murano_db_password'], $murano_base_hash['db_password'])
  $murano_user_password   = pick($settings_hash['murano_user_password'], $murano_base_hash['user_password'])
  $murano_rabbit_user     = pick($settings_hash['murano_rabbit_user'], 'murano')
  $murano_rabbit_password = pick($settings_hash['murano_rabbit_password'], $murano_base_hash['rabbit_password'])
  $murano_rabbit_host     = pick($settings_hash['murano_rabbit_vhost'], $murano_base_hash['rabbit']['vhost'])
  $murano_rabbit_port     = pick($settings_hash['murano_rabbit_port'], $murano_base_hash['rabbit']['port'])

  $murano_cfapi_enabled       = $murano_plugin['murano_cfapi']
  $murano_repo_url            = $murano_plugin['murano_repo_url']
  $murano_glance_artifacts    = $murano_plugin['murano_glance_artifacts']
  $application_catalog_ui     = $murano_plugin['application_catalog_ui']
  $syslog_log_facility_murano = hiera('syslog_log_facility_murano', 'LOG_LOCAL0')
  $default_log_levels         = hiera('default_log_levels')

  ###################
  $calculated_content = inline_template('
murano_plugin:
  murano_standalone: <%= @murano_role_exists %>
  murano_ipaddresses:
<%
@murano_nodes_ips.each do |muranoip|
%>    - <%= muranoip %>
<% end -%>
  murano_nodes:
<%
@murano_nodes_names.each do |muranoname|
%>    - <%= muranoname %>
<% end -%>
  rabbit:
    user: <%= @murano_rabbit_user %>
    password: <%= @murano_rabbit_password %>
    vhost: <%= @murano_rabbit_host %>
    port: <%= @murano_rabbit_port %>
  db_password: <%= @murano_db_password %>
  user_password: <%= @murano_user_password %>
  murano_repo_url: <%= @murano_repo_url %>
  plugins:
    glance_artifacts_plugin:
      enabled: <%= @murano_glance_artifacts %>
murano_cfapi_plugin:
  enabled: <%= @murano_cfapi_enabled %>
app_catalog_ui: <%= @application_catalog_ui %>
syslog_log_facility_murano: <%= @syslog_log_facility_murano %>
"murano::logging::default_log_levels":
<%
@default_log_levels.each do |k,v|
%>  <%= k %>: <%= v %>
<% end -%>
')

  ###################
  file {'/etc/hiera/override':
    ensure  => directory,
  } ->
  file { "${hiera_dir}/${plugin_yaml}":
    ensure  => file,
    content => "${calculated_content}",
  }

  package {'ruby-deep-merge':
    ensure  => 'installed',
  }
}
