# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class fw::profiles::roller {

    case $::fqdn {
        /.*\.(scl3|mdc1|mdc2)\.mozilla\.com/: {
            include ::fw::roles::ssh_from_rejh_logging
            include ::fw::roles::nrpe_from_nagios
            include ::fw::roles::roller_api_from_anywhere
        }
        default:{
            # Silently skip other DCs
        }
    }
}
