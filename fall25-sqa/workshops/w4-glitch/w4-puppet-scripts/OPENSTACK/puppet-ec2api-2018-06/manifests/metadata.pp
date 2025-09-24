# == Class: ec2api::metadata
#
# Manage the EC2 API Metadata service and its configuration
#
# === Parameters
#
# ==== Metadata
#
# [*nova_metadata_ip*]
#   IP address used by Nova metadata server
#   Default: $::os_service_default
#
# [*nova_metadata_port*]
#   TCP Port used by Nova metadata server
#   Default: $::os_service_default
#
# [*nova_metadata_protocol*]
#   Protocol to access nova metadata, http or https
#   Default: $::os_service_default
#
# [*nova_metadata_insecure*]
#   Allow to perform insecure SSL (https) requests to nova metadata
#   Default: $::os_service_default
#
# [*auth_ca_cert*]
#   Certificate Authority public key (CA cert) file for ssl
#   Default: $::os_service_default
#
# [*nova_client_cert*]
#   Client certificate for nova metadata api server
#   Default: $::os_service_default
#
# [*nova_client_priv_key*]
#   Private key of client certificate
#   Default: $::os_service_default
#
# [*metadata_proxy_shared_secret*]
#   Shared secret to sign instance-id request
#   Default: $::os_service_default
#
# ==== Service
#
# [*metadata_listen*]
#   The IP address on which the metadata API will listen.
#   Default: $::os_service_default
#
# [*metadata_listen_port*]
#   The port on which the metadata API will listen.
#   Default: $::os_service_default
#
# [*metadata_use_ssl*]
#   Enable ssl connections or not for EC2 API Metadata.
#   Default: $::os_service_default
#
# [*metadata_workers*]
#   Number of workers for metadata service.
#   The default will be the number of CPUs available.
#   Default: $::os_workers
#
# ==== Manage Service
#
# [*manage_service*]
#   Should the METADATA service actually be managed by Puppet?
#   Default: true
#
# [*service_name*]
#   The real system name of the Metadata service.
#   Default: $::ec2api::params::metadata_service_name
#
# [*enabled*]
#   Should the service be enabled and started (true) of disabled and stopped (false).
#   Default: true
#
class ec2api::metadata (
  # Metadata
  $nova_metadata_ip             = $::os_service_default,
  $nova_metadata_port           = $::os_service_default,
  $nova_metadata_protocol       = $::os_service_default,
  $nova_metadata_insecure       = $::os_service_default,
  $auth_ca_cert                 = $::os_service_default,
  $nova_client_cert             = $::os_service_default,
  $nova_client_priv_key         = $::os_service_default,
  $metadata_proxy_shared_secret = $::os_service_default,
  # Service
  $metadata_listen              = $::os_service_default,
  $metadata_listen_port         = $::os_service_default,
  $metadata_use_ssl             = $::os_service_default,
  $metadata_workers             = $::os_workers,
  # Manage service
  $manage_service               = true,
  $service_name                 = $::ec2api::params::metadata_service_name,
  $enabled                      = true,
) inherits ::ec2api::params {

  include ::ec2api::deps

  validate_bool($manage_service)
  validate_string($service_name)
  validate_bool($enabled)

  ec2api_config {
    'metadata/nova_metadata_ip':             value => $nova_metadata_ip;
    'metadata/nova_metadata_port':           value => $nova_metadata_port;
    'metadata/nova_metadata_protocol':       value => $nova_metadata_protocol;
    'metadata/nova_metadata_insecure':       value => $nova_metadata_insecure;
    'metadata/auth_ca_cert':                 value => $auth_ca_cert;
    'metadata/nova_client_cert':             value => $nova_client_cert;
    'metadata/nova_client_priv_key':         value => $nova_client_priv_key;
    'metadata/metadata_proxy_shared_secret': value => $metadata_proxy_shared_secret, secret => true;
    'DEFAULT/metadata_listen':               value => $metadata_listen;
    'DEFAULT/metadata_listen_port':          value => $metadata_listen_port;
    'DEFAULT/metadata_use_ssl':              value => $metadata_use_ssl;
    'DEFAULT/metadata_workers':              value => $metadata_workers;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'openstack-ec2-metadata-service' :
    ensure     => $service_ensure,
    name       => $service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => 'ec2api-service',
  }

}
