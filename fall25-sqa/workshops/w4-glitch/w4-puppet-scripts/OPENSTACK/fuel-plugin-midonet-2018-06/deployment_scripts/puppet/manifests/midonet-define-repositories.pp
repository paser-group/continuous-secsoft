#    Copyright 2016 Midokura, SARL.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
notice('MODULAR: midonet-define-repositories.pp')

$midonet_settings  = hiera('midonet')
$mem               = $midonet_settings['mem']
$mem_version       = $midonet_settings['midonet_version']
$mem_user          = $midonet_settings['mem_repo_user']
$mem_password      = $midonet_settings['mem_repo_password']
$midonet_version   = $midonet_settings['midonet_version']
$openstack_release = 'mitaka'

include apt
include apt::update
include midonet::params


if $mem {
  $midonet_repo_url = "http://${mem_user}:${mem_password}@${midonet::params::midonet_repo_baseurl}/mem-${mem_version}"
}
else {
  $midonet_repo_url = "http://${midonet::params::midonet_repo_baseurl}/midonet-${midonet_version}"
}

apt::key { 'midorepo':
  id     => 'E9996503AEB005066261D3F38DDA494E99143E75',
  source => $midonet::params::midonet_key_url
} ->

apt::source {'midonet':
    comment  => 'Midonet apt repository',
    location => $midonet_repo_url,
    release  => 'unstable',
    key      => {
          'id'     => 'E9996503AEB005066261D3F38DDA494E99143E75',
          'server' => 'subkeys.pgp.net',
    },
    include  => {
          'src' => false,
  }
} ->

apt::source {'midonet-openstack-integration':
    comment  => 'Midonet apt plugin repository',
    location => "http://${midonet::params::midonet_repo_baseurl}/openstack-${openstack_release}",
    release  => 'stable',
    include  => {
          'src' => false,
  }
} ->

apt::source {'midonet-openstack-misc':
    comment  => 'Midonet 3rd party tools and libraries',
    location => "http://${midonet::params::midonet_repo_baseurl}/misc",
    release  => 'stable',
    include  => {
          'src' => false,
  }
}

# Dummy exec to wrap apt_update
exec {'update-midonet-repos':
    command => '/bin/true',
    require => [Exec['apt_update'],
                Apt::Source['midonet'],
                Apt::Source['midonet-openstack-integration']]

}

Apt::Source<| |> -> Exec<| title == 'update-midonet-repos' |>
