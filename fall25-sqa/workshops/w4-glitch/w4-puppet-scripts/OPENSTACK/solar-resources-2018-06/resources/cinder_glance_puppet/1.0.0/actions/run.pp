$resource = hiera($::resource_name)

$glance_api_version          = $resource['input']['glance_api_version']
$glance_num_retries          = $resource['input']['glance_num_retries']
$glance_api_insecure         = $resource['input']['glance_api_insecure']
$glance_api_ssl_compression  = $resource['input']['glance_api_ssl_compression']
$glance_request_timeout      = $resource['input']['glance_request_timeout']
$glance_api_servers_host     = $resource['input']['glance_api_servers_host']
$glance_api_servers_port     = $resource['input']['glance_api_servers_port']

class {'cinder::glance':
  glance_api_servers          => "${glance_api_servers_host}:${glance_api_servers_port}",
  glance_api_version          => $glance_api_version,
  glance_num_retries          => $glance_num_retries,
  glance_api_insecure         => $glance_api_insecure,
  glance_api_ssl_compression  => $glance_api_ssl_compression,
  glance_request_timeout      => $glance_request_timeout,
}
