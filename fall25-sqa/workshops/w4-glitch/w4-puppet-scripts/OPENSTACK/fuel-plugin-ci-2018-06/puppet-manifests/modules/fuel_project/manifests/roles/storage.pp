# Class: fuel_project::roles::storage
#
class fuel_project::roles::storage (
  $iso_vault_fqdn = "iso.${::fqdn}",
) {
  class { '::fuel_project::common' :}
  class { '::fuel_project::apps::mirror' :}

  if (!defined(Class['::fuel_project::nginx'])) {
    class { '::fuel_project::nginx' :}
  }

  ::nginx::resource::vhost { 'iso-vault' :
    ensure              => 'present',
    www_root            => '/var/www/iso-vault',
    access_log          => '/var/log/nginx/access.log',
    error_log           => '/var/log/nginx/error.log',
    format_log          => 'proxy',
    server_name         => [$iso_vault_fqdn, "iso.${::fqdn}"],
    location_cfg_append => {
        autoindex => 'on',
    },
  }
}
