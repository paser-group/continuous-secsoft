# Class: fuel_project::apps::partnerappliance
#
class fuel_project::apps::partnerappliance (
  $authorized_keys,
  $group            = 'appliance',
  $home_dir         = '/var/www/appliance',
  $data_dir         = "${home_dir}/data",
  $user             = 'appliance',
  $vhost            = 'appliance',
  $service_fqdn     = "${vhost}.${::domain}",
) {

  # manage user $HOME manually, since we don't need .bash* stuff
  # but only ~/.ssh/
  file { $home_dir :
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => User[$user]
  }

  file { $data_dir :
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => [
      File[$home_dir],
    ]
  }

  user { $user :
    ensure     => 'present',
    system     => true,
    managehome => false,
    home       => $home_dir,
    shell      => '/bin/sh',
  }

  $opts = [
    "command=\"rsync --server -rlpt --delete . ${data_dir}\"",
    'no-agent-forwarding',
    'no-port-forwarding',
    'no-user-rc',
    'no-X11-forwarding',
    'no-pty',
  ]

  create_resources(ssh_authorized_key, $authorized_keys, {
    ensure  => 'present',
    user    => $user,
    require => [
      File[$home_dir],
      User[$user],
    ],
    options => $opts,
  })

  ::nginx::resource::vhost { $vhost :
    server_name => [ $service_fqdn ],
    www_root    => $data_dir,
  }
}
