# The puppet installs ScaleIO MDM packages.

notice('MODULAR: scaleio: mdm_package')

$scaleio = hiera('scaleio')
if $scaleio['metadata']['enabled'] {
  if ! $scaleio['existing_cluster'] {
    $node_ips = split($::ip_address_array, ',')
    if ! empty(intersection(split($::controller_ips, ','), $node_ips))
    {
      notify {'Mdm server installation': } ->
      class {'::scaleio::mdm_server':
        ensure  => 'present',
        pkg_ftp => $scaleio['pkg_ftp'],
      }
    } else {
      notify{'Skip deploying mdm server because it is not controller': }
    }
  } else {
    notify{'Skip deploying mdm server because of using existing cluster': }
  }
}
