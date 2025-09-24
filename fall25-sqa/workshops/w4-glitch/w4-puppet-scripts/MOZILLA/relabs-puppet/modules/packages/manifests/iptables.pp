# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class packages::iptables {

    # We purposely install iptables with exec so not to clash with the resources
    # defined in the Firewall module. This issue has been fixed in puppet 4.3.0
    # https://tickets.puppetlabs.com/browse/PUP-1963
    # https://tickets.puppetlabs.com/browse/PUP-5874
    case $::operatingsystem {
        CentOS: {
            exec { 'install iptables':
                command => '/usr/bin/yum install iptables -y',
                creates => '/sbin/iptables';
            }
            exec { 'install ip6tables':
                command => '/usr/bin/yum install iptables-ipv6 -y',
                creates => '/sbin/ip6tables';
            }
        }
        default: {
            fail("Cannot install on ${::operatingsystem}")
        }
    }
}
