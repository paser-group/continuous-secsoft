# Class: fuel_project::roles::perestroika::publisher
#
# jenkins slave host for publishing of packages
# see hiera file for list and params of used classes

class fuel_project::roles::perestroika::publisher (
  $gpg_content_priv,
  $gpg_content_pub,
  $gpg_id_priv,
  $gpg_id_pub,
  $gpg_pub_key_owner  = 'jenkins',
  $gpg_priv_key_owner = 'jenkins',
  $packages = [
    'createrepo',
    'devscripts',
    'expect',
    'python-lxml',
    'reprepro',
    'rpm',
    'yum-utils',
  ],
) {

  ensure_packages($packages)

  if( ! defined(Class['::fuel_project::jenkins::slave'])) {
    class { '::fuel_project::jenkins::slave' : }
  }

  class { '::gnupg' : }

  gnupg_key { 'perestroika_gpg_public':
    ensure      => 'present',
    key_id      => $gpg_id_pub,
    user        => $gpg_pub_key_owner,
    key_content => $gpg_content_pub,
    key_type    => public,
    require     => [
      User['jenkins'],
      Class['::fuel_project::jenkins::slave'],
    ],
  }

  gnupg_key { 'perestroika_gpg_private':
    ensure      => 'present',
    key_id      => $gpg_id_priv,
    user        => $gpg_priv_key_owner,
    key_content => $gpg_content_priv,
    key_type    => private,
    require     => [
      User['jenkins'],
      Class['::fuel_project::jenkins::slave'],
    ],
  }
}