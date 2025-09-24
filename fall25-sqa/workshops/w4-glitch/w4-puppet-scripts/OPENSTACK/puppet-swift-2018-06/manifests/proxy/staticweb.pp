#
# Configure swift staticweb, see documentation for Swift staticweb middleware
# to understand more about configuration.
#
# == Dependencies
#
# == Examples
#
#  include 'swift::proxy::staticweb'
#
# == Parameters
#
# [*url_base*]
#   (optional) The URL scheme and/or the host name used to generate redirects.
#   Defaults to $::os_service_default.
#
# == Authors
#
#   Mehdi Abaakouk <sileht@sileht.net>
#
# == Copyright
#
# Copyright 2012 eNovance licensing@enovance.com
#
class swift::proxy::staticweb(
  $url_base = $::os_service_default
) {

  include ::swift::deps

  swift_proxy_config {
    'filter:staticweb/use':              value => 'egg:swift#staticweb';
    'filter:staticweb/url_base':         value => $url_base;
  }
}
