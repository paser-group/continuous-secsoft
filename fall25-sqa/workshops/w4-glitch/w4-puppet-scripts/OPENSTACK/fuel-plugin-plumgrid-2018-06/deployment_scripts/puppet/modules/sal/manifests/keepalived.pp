#
# Copyright (c) 2016, PLUMgrid Inc, http://plumgrid.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class sal::keepalived ($virtual_ip,
                       $mgmt_dev,
                       $keepalived_password = 'keepaliv',
                       ) {
Exec { path => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin', ] }

$keepalived_priority = 100
$keepalived_router_id = regsubst($virtual_ip, '^\d+\.\d+\.\d+\.(\d+)$', '\1')

if $keepalived_router_id == '' {
    fail('invalid virtual_ip, use x.x.x.x notation')
  }

exec { 'pick-vip_dev-by-route':
    creates => "${::sal::lxc_data_path}/conf/pg/.auto_dev-vip",
    command => "ip route get ${virtual_ip} | awk 'NR==1 && \$2==\"dev\" {print \$3; exit 0} NR==1 && \$2==\"via\" {print \$5; exit 0} NR>1 { exit 1 }' > ${::sal::lxc_data_path}/conf/pg/.auto_dev-vip || ip addr show | awk '/(${virtual_ip})\\// {print \$NF}' > ${::sal::lxc_data_path}/conf/pg/.auto_dev-vip",
    require => Package['plumgrid-lxc'],
}->
exec { 'check-vip_dev-by-route':
    command => 'echo "Please provide \"mgmt_dev\" parameter for \"sal\" class using foreman UI" && exit 1',
    unless  => "test -s ${::sal::lxc_data_path}/conf/pg/.auto_dev-vip",
}

file { "${::sal::lxc_data_path}/conf/etc/.keepalived.conf":
    ensure  => file,
    content => template('sal/keepalived.conf.erb'),
    require => Package['plumgrid-lxc'],
}~>
exec { 'generate-keepalived.conf':
    refreshonly => true,
    command     => "sed \"s/%AUTO_DEV%/`head -n1 ${::sal::lxc_data_path}/conf/pg/.auto_dev-vip`/g\" ${::sal::lxc_data_path}/conf/etc/.keepalived.conf > ${::sal::lxc_data_path}/conf/etc/keepalived.conf",
    subscribe   => Exec['pick-vip_dev-by-route'],
    notify      => Service['plumgrid'],
}
}
