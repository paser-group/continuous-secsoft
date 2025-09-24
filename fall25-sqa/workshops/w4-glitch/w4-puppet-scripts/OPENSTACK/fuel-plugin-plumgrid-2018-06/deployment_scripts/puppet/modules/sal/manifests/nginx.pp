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

class sal::nginx ($plumgrid_ip = '',
                  $md_ip = '127.0.0.1',
                  $virtual_ip = '',
                  $use_default_cert = true,
                  ) {
  if ($use_default_cert) {
    $nginx_cert = "${::sal::lxc_data_path}/ssl/nginx/default.crt"
    $nginx_key = "${::sal::lxc_data_path}/ssl/nginx/default.key"
  } else {
    # update with your parameters to generate a self-signed certificate
    $location = "Sunnyvale"
    $country = "US"
    $state = "CA"
    $organization = "ACME"
    $unit = "IT"
    $commonname = "www.example.com"
    $keyname = "www_example_com"

    $nginx_cert = "${::sal::lxc_data_path}/ssl/nginx/${keyname}.crt"
    $nginx_key = "${::sal::lxc_data_path}/ssl/nginx/${keyname}.key"

    $subject = "/C=${country}/ST=${state}/L=${location}/O=${organization}/OU=${unit}/CN=${commonname}"
    $createcertificate = "/usr/bin/openssl req -new -newkey rsa:2048 -x509 -days 3650 -nodes -out ${nginx_cert} -keyout ${nginx_key} -subj \"${subject}\""

    exec { "openssl-csr":
      command => $createcertificate,
      creates => [$nginx_cert, $nginx_key],
      require => Package['plumgrid-lxc'],
    }
  }

  $nginx_virtual_ip = regsubst($virtual_ip, '^(\d+\.\d+\.\d+\.\d+)$', '\1')
  if $nginx_virtual_ip == '' {
    fail('invalid virtual_ip, use x.x.x.x notation')
  }
  $nginx_real_ips = split($plumgrid_ip, ',')
  file { "${::sal::lxc_data_path}/conf/pg/nginx.conf":
    ensure => file,
    content => template('sal/default.conf.erb'),
    require => Package['plumgrid-lxc'],
  }
}
