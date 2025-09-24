prepare_network_config(hiera_hash('network_scheme'))
$ceph_cluster_network    = get_network_role_property('ceph/replication', 'network')

notify{"The value is: ${ceph_cluster_network}": }
