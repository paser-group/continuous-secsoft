# Class: ssh::authorized_keys
class ssh::authorized_keys {
  $keys = hiera_hash('ssh::authorized_keys::keys', {})
  create_resources(ssh_authorized_key,
    $keys, {
      ensure => present,
      user => 'root'
    }
  )
}
