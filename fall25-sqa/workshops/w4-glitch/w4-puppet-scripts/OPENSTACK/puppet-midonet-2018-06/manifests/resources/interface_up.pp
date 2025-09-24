# == Resource: midonet::resources::interface_up
#
# Brings an interface with the corresponding IP address up. Necessary for the
# BGP setup, otherwise the bgpd process won't start.
#

define midonet::resources::interface_up(
  String $mac_address
) {

  exec { 'bring_interface_up':
    path    => '/usr/bin:/usr/sbin:/sbin:/bin',
    command => "ip link set dev $(ip -o link | grep ${mac_address} | awk '{print \$2}' | tr -d ':') up",
    onlyif  => "ip -o link | grep ${mac_address} | grep 'state DOWN'"
  }

}
