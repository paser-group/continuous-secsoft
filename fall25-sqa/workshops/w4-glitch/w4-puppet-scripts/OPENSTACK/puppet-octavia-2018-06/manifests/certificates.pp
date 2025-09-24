# == Class: octavia::certificates
#
#  Configure the octavia certificates for TLS authentication
#
# === Parameters
#
# [*ca_certificate*]
#   (Optional) Path to the CA certificate for Octavia
#   Defaults to $::os_service_default
#
# [*ca_private_key*]
#   (Optional) Path for private key used to sign certificates
#   Defaults to $::os_service_default
#
# [*ca_private_key_passphrase*]
#   (Optional) CA password used to sign certificates
#   Defaults to $::os_service_default
#
# [*client_cert*]
#   (Optional) Path for client certificate used to connect to amphorae.
#   Defaults to $::os_service_default
#
# [*ca_certificate_data*]
#   (Optional) CA certificate for Octavia
#   Defaults to undef
#
# [*ca_private_key_data*]
#   (Optional) CA private key for signing certificates
#   Defaults to undef
#
# [*client_cert_data*]
#   (Optional) Client certificate used for connecting to amphorae
#   Defaults to undef
#
# [*file_permission_owner*]
#   (Optional) User account for file owner.
#   Defaults to 'octavia'
#
# [*file_permission_group*]
#   (Optional) User group for file permissions
#   Defaults to 'octavia'
#
class octavia::certificates (
  $ca_certificate            = $::os_service_default,
  $ca_private_key            = $::os_service_default,
  $ca_private_key_passphrase = $::os_service_default,
  $client_cert               = $::os_service_default,
  $ca_certificate_data       = undef,
  $ca_private_key_data       = undef,
  $client_cert_data          = undef,
  $file_permission_owner     = 'octavia',
  $file_permission_group     = 'octavia'
) {

  include ::octavia::deps

  octavia_config {
    'certificates/ca_certificate'            : value => $ca_certificate;
    'certificates/ca_private_key'            : value => $ca_private_key;
    'certificates/ca_private_key_passphrase' : value => $ca_private_key_passphrase;
    'controller_worker/client_ca'            : value => $ca_certificate;
    'haproxy_amphora/client_cert'            : value => $client_cert;
    'haproxy_amphora/server_ca'              : value => $ca_certificate;
  }

  # The file creation will create the parent directory for each file if necessary, but
  # only to one level.
  if $ca_certificate_data {
    if is_service_default($ca_certificate) {
      fail('You must provide a path for storing the CA certificate')
    }
    ensure_resource('file', dirname($ca_certificate), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755'
    })
    file { $ca_certificate:
      ensure  => file,
      content => $ca_certificate_data,
      group   => $file_permission_owner,
      owner   => $file_permission_group,
      mode    => '0755',
      replace => true
    }
  }
  if $ca_private_key_data {
    if is_service_default($ca_private_key) {
      fail('You must provide a path for storing the CA private key')
    }
    ensure_resource('file', dirname($ca_private_key), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755'
    })
    file { $ca_private_key:
      ensure  => file,
      content => $ca_private_key_data,
      group   => $file_permission_owner,
      owner   => $file_permission_group,
      mode    => '0755',
      replace => true
    }
  }
  if $client_cert_data {
    if is_service_default($client_cert) {
      fail('You must provide a path for storing the client certificate')
    }
    ensure_resource('file', dirname($client_cert), {
      ensure => directory,
      owner  => $file_permission_owner,
      group  => $file_permission_group,
      mode   => '0755'
    })
    file { $client_cert:
      ensure  => file,
      content => $client_cert_data,
      group   => $file_permission_owner,
      owner   => $file_permission_group,
      mode    => '0755',
      replace => true
    }
  }
}
