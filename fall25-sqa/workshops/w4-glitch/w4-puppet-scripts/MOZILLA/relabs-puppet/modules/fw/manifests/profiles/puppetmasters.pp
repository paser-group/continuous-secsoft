# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class fw::profiles::puppetmasters {

    case $::fqdn {
        /.*\.mdc1\.mozilla\.com/: {
            include ::fw::roles::puppetmaster_from_all_releng
            include ::fw::roles::ssh_from_anywhere_logging
        }
        default:{
            # Silently skip other DCs
        }
    }
}
