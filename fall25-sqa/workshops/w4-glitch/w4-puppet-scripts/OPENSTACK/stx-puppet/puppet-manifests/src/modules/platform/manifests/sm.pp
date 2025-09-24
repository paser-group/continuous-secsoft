class platform::sm::params (
  $mgmt_ip_multicast = undef,
  $cluster_host_ip_multicast = undef,
) { }

class platform::sm
  inherits ::platform::sm::params {

  include ::platform::params
  $controller_0_hostname         = $::platform::params::controller_0_hostname
  $controller_1_hostname         = $::platform::params::controller_1_hostname
  $platform_sw_version           = $::platform::params::software_version
  $region_config                 = $::platform::params::region_config
  $region_2_name                 = $::platform::params::region_2_name
  $system_mode                   = $::platform::params::system_mode
  $system_type                   = $::platform::params::system_type
  $stx_openstack_applied         = $::platform::params::stx_openstack_applied
  $dc_role                       = $::platform::params::distributed_cloud_role

  include ::platform::network::pxeboot::params
  if $::platform::network::pxeboot::params::interface_name {
    $pxeboot_ip_interface = $::platform::network::pxeboot::params::interface_name
  } else {
    # Fallback to using the management interface for PXE boot network
    $pxeboot_ip_interface = $::platform::network::mgmt::params::interface_name
  }
  $pxeboot_ip_param_ip           = $::platform::network::pxeboot::params::controller_address
  $pxeboot_ip_param_mask         = $::platform::network::pxeboot::params::subnet_prefixlen

  include ::platform::network::mgmt::params
  $mgmt_ip_interface             = $::platform::network::mgmt::params::interface_name
  $mgmt_ip_param_ip              = $::platform::network::mgmt::params::controller_address
  $mgmt_ip_param_mask            = $::platform::network::mgmt::params::subnet_prefixlen

  include ::platform::network::cluster_host::params
  $cluster_host_ip_interface     = $::platform::network::cluster_host::params::interface_name
  $cluster_host_ip_param_ip      = $::platform::network::cluster_host::params::controller_address
  $cluster_host_ip_param_mask    = $::platform::network::cluster_host::params::subnet_prefixlen

  include ::platform::network::oam::params
  $oam_ip_interface              = $::platform::network::oam::params::interface_name
  $oam_ip_param_ip               = $::platform::network::oam::params::controller_address
  $oam_ip_param_mask             = $::platform::network::oam::params::subnet_prefixlen

  include ::platform::network::ironic::params
  $ironic_ip_interface           = $::platform::network::ironic::params::interface_name
  $ironic_ip_param_ip            = $::platform::network::ironic::params::controller_address
  $ironic_ip_param_mask          = $::platform::network::ironic::params::subnet_prefixlen

  include ::platform::drbd::pgsql::params
  $pg_drbd_resource              = $::platform::drbd::pgsql::params::resource_name
  $pg_fs_device                  = $::platform::drbd::pgsql::params::device
  $pg_fs_directory               = $::platform::drbd::pgsql::params::mountpoint
  $pg_data_dir                   = "${pg_fs_directory}/${platform_sw_version}"

  include ::platform::drbd::platform::params
  $platform_drbd_resource        = $::platform::drbd::platform::params::resource_name
  $platform_fs_device            = $::platform::drbd::platform::params::device
  $platform_fs_directory         = $::platform::drbd::platform::params::mountpoint

  include ::platform::drbd::rabbit::params
  $rabbit_drbd_resource          = $::platform::drbd::rabbit::params::resource_name
  $rabbit_fs_device              = $::platform::drbd::rabbit::params::device
  $rabbit_fs_directory           = $::platform::drbd::rabbit::params::mountpoint

  include ::platform::drbd::extension::params
  $extension_drbd_resource          = $::platform::drbd::extension::params::resource_name
  $extension_fs_device              = $::platform::drbd::extension::params::device
  $extension_fs_directory           = $::platform::drbd::extension::params::mountpoint

  include ::platform::drbd::dc_vault::params
  $drbd_patch_enabled           = $::platform::drbd::dc_vault::params::service_enabled
  $patch_drbd_resource          = $::platform::drbd::dc_vault::params::resource_name
  $patch_fs_device              = $::platform::drbd::dc_vault::params::device
  $patch_fs_directory           = $::platform::drbd::dc_vault::params::mountpoint

  include ::platform::drbd::etcd::params
  $etcd_drbd_resource           = $::platform::drbd::etcd::params::resource_name
  $etcd_fs_device               = $::platform::drbd::etcd::params::device
  $etcd_fs_directory            = $::platform::drbd::etcd::params::mountpoint

  include ::platform::drbd::dockerdistribution::params
  $dockerdistribution_drbd_resource          = $::platform::drbd::dockerdistribution::params::resource_name
  $dockerdistribution_fs_device              = $::platform::drbd::dockerdistribution::params::device
  $dockerdistribution_fs_directory           = $::platform::drbd::dockerdistribution::params::mountpoint

  include ::platform::helm::repositories::params
  $helmrepo_fs_source_dir = $::platform::helm::repositories::params::source_helm_repos_base_dir
  $helmrepo_fs_target_dir = $::platform::helm::repositories::params::target_helm_repos_base_dir

  include ::platform::deviceimage::params
  $deviceimage_fs_source_dir = $::platform::deviceimage::params::source_deviceimage_base_dir
  $deviceimage_fs_target_dir = $::platform::deviceimage::params::target_deviceimage_base_dir

  include ::platform::drbd::cephmon::params
  $cephmon_drbd_resource          = $::platform::drbd::cephmon::params::resource_name
  $cephmon_fs_device              = $::platform::drbd::cephmon::params::device
  $cephmon_fs_directory           = $::platform::drbd::cephmon::params::mountpoint

  include ::platform::rook::params
  $rookmon_drbd_resource          = $::platform::drbd::rookmon::params::resource_name
  $rookmon_fs_device              = $::platform::drbd::rookmon::params::device
  $rookmon_fs_directory           = $::platform::drbd::rookmon::params::mountpoint

  include ::openstack::keystone::params
  $keystone_api_version          = $::openstack::keystone::params::api_version
  $keystone_identity_uri         = $::openstack::keystone::params::identity_uri
  $keystone_host_url             = $::openstack::keystone::params::host_url
  $keystone_region               = $::openstack::keystone::params::region_name

  include ::platform::amqp::params
  $amqp_server_port              = $::platform::amqp::params::port
  $rabbit_node_name              = $::platform::amqp::params::node
  $rabbit_mnesia_base            = "/var/lib/rabbitmq/${platform_sw_version}/mnesia"

  include ::platform::ldap::params
  $ldapserver_remote             = $::platform::ldap::params::ldapserver_remote

  # This variable is used also in create_sm_db.sql.
  # please change that one as well when modifying this variable
  $rabbit_pid              = '/var/run/rabbitmq/rabbitmq.pid'

  $rabbitmq_server = '/usr/lib/rabbitmq/bin/rabbitmq-server'
  $rabbitmqctl     = '/usr/lib/rabbitmq/bin/rabbitmqctl'

  include ::platform::mtce::params
  $sm_client_port                 = $::platform::mtce::params::sm_client_port
  $sm_server_port                 = $::platform::mtce::params::sm_server_port

  ############ NFS Parameters ################

  # Platform NFS network is over the management network
  $platform_nfs_ip_interface   = $::platform::network::mgmt::params::interface_name
  $platform_nfs_ip_param_ip    = $::platform::network::mgmt::params::platform_nfs_address
  $platform_nfs_ip_param_mask  = $::platform::network::mgmt::params::subnet_prefixlen
  $platform_nfs_ip_network_url = $::platform::network::mgmt::params::subnet_network_url


  $platform_nfs_subnet_url = "${platform_nfs_ip_network_url}/${platform_nfs_ip_param_mask}"

  # lint:ignore:140chars
  $nfs_server_mgmt_exports = "${platform_nfs_subnet_url}:${platform_fs_directory},${platform_nfs_subnet_url}:${extension_fs_directory}"
  $nfs_server_mgmt_mounts  = "${platform_fs_device}:${platform_fs_directory},${extension_fs_device}:${extension_fs_directory}"
  # lint:endignore:140chars

  ################## Openstack Parameters ######################

  # Keystone
  if $region_config {
    $os_mgmt_ip             = $keystone_identity_uri
    $os_keystone_auth_url   = "${os_mgmt_ip}/${keystone_api_version}"
    $os_region_name         = $region_2_name
  } else {
    $os_auth_ip             = $keystone_host_url
    $os_keystone_auth_url   = "http://${os_auth_ip}:5000/${keystone_api_version}"
    $os_region_name         = $keystone_region
  }

  # Barbican
  include ::openstack::barbican::params

  $ost_cl_ctrl_host         = $::platform::network::mgmt::params::controller_address_url

  include ::platform::client::params

  $os_username              = $::platform::client::params::admin_username
  $os_project_name          = 'admin'
  $os_auth_url              = $os_keystone_auth_url
  $system_url               = "http://${ost_cl_ctrl_host}:6385"
  $os_user_domain_name      = $::platform::client::params::admin_user_domain
  $os_project_domain_name   = $::platform::client::params::admin_project_domain

  # Ceph-Rados-Gateway
  include ::platform::ceph::params
  $ceph_configured = $::platform::ceph::params::service_enabled
  $rook_configured = $::platform::rook::params::service_enabled
  $rgw_configured = $::platform::ceph::params::rgw_enabled

  if $system_mode == 'simplex' {
    $hostunit = '0'
    $management_my_unit_ip   = $::platform::network::mgmt::params::controller0_address
    $oam_my_unit_ip          = $::platform::network::oam::params::controller_address
    $cluster_host_my_unit_ip = $::platform::network::cluster_host::params::controller_address
  } else {
    case $::hostname {
      $controller_0_hostname: {
        $hostunit = '0'
        $management_my_unit_ip   = $::platform::network::mgmt::params::controller0_address
        $management_peer_unit_ip = $::platform::network::mgmt::params::controller1_address
        $oam_my_unit_ip          = $::platform::network::oam::params::controller0_address
        $oam_peer_unit_ip        = $::platform::network::oam::params::controller1_address
        $cluster_host_my_unit_ip = $::platform::network::cluster_host::params::controller0_address
        $cluster_host_peer_unit_ip = $::platform::network::cluster_host::params::controller1_address
      }
      $controller_1_hostname: {
        $hostunit = '1'
        $management_my_unit_ip   = $::platform::network::mgmt::params::controller1_address
        $management_peer_unit_ip = $::platform::network::mgmt::params::controller0_address
        $oam_my_unit_ip          = $::platform::network::oam::params::controller1_address
        $oam_peer_unit_ip        = $::platform::network::oam::params::controller0_address
        $cluster_host_my_unit_ip = $::platform::network::cluster_host::params::controller1_address
        $cluster_host_peer_unit_ip = $::platform::network::cluster_host::params::controller0_address
      }
      default: {
        $hostunit = '2'
        $management_my_unit_ip = undef
        $management_peer_unit_ip = undef
        $oam_my_unit_ip = undef
        $oam_peer_unit_ip = undef
        $cluster_host_my_unit_ip = undef
        $cluster_host_peer_unit_ip = undef
      }
    }
  }


  # Add a shell for the postgres. By default WRL sets the shell to /bin/false.
  user { 'postgres':
    shell => '/bin/sh'
  }

  # lint:ignore:140chars

  if str2bool($::is_virtual) {
    exec { 'Configure sm process priority':
      command => 'sm-configure system --sm_process_priority -10',
    }
  }

  if $system_mode == 'simplex' {
    exec { 'Deprovision oam-ip service group member':
      command => 'sm-deprovision service-group-member oam-services oam-ip',
    }
    -> exec { 'Deprovision oam-ip service':
      command => 'sm-deprovision service oam-ip',
    }

    exec { 'Configure OAM Interface':
      command => "sm-configure interface controller oam-interface \"\" ${oam_my_unit_ip} 2222 2223 \"\" 2222 2223",
    }

    exec { 'Configure Management Interface':
      command => "sm-configure interface controller management-interface \"\" ${management_my_unit_ip} 2222 2223 \"\" 2222 2223",
    }

    exec { 'Configure Cluster Host Interface':
      command => "sm-configure interface controller cluster-host-interface \"\" ${cluster_host_my_unit_ip} 2222 2223 \"\" 2222 2223",
    }

  } else {
    exec { 'Configure OAM Interface':
      command => "sm-configure interface controller oam-interface \"\" ${oam_my_unit_ip} 2222 2223 ${oam_peer_unit_ip} 2222 2223",
    }
    exec { 'Configure Management Interface':
      command => "sm-configure interface controller management-interface ${mgmt_ip_multicast} ${management_my_unit_ip} 2222 2223 ${management_peer_unit_ip} 2222 2223",
    }

    exec { 'Configure Cluster Host Interface':
      command => "sm-configure interface controller cluster-host-interface ${cluster_host_ip_multicast} ${cluster_host_my_unit_ip} 2222 2223 ${cluster_host_peer_unit_ip} 2222 2223",
    }
  }

  exec { 'Configure OAM IP':
    command => "sm-configure service_instance oam-ip oam-ip \"ip=${oam_ip_param_ip},cidr_netmask=${oam_ip_param_mask},nic=${oam_ip_interface},arp_count=7\"",
  }

  if $system_mode == 'duplex-direct' or $system_mode == 'simplex' {
      exec { 'Configure Management IP':
        command => "sm-configure service_instance management-ip management-ip \"ip=${mgmt_ip_param_ip},cidr_netmask=${mgmt_ip_param_mask},nic=${mgmt_ip_interface},arp_count=7,dc=yes\"",
      }
  } else {
      # For ipv6 the only way to initiate outgoing connections
      # over the fixed ips is to set preferred_lft to 0 for the
      # floating ips so that they are not used
      if $::platform::network::mgmt::params::subnet_version == $::platform::params::ipv6 {
        $preferred_lft = '0'
      } else {
        $preferred_lft = 'forever'
      }
      exec { 'Configure Management IP':
        command => "sm-configure service_instance management-ip management-ip \"ip=${mgmt_ip_param_ip},cidr_netmask=${mgmt_ip_param_mask},nic=${mgmt_ip_interface},arp_count=7,preferred_lft=${preferred_lft}\"",
      }
  }


  if $system_mode == 'duplex-direct' or $system_mode == 'simplex' {
    exec { 'Configure Cluster Host IP service instance':
      command =>
          "sm-configure service_instance cluster-host-ip cluster-host-ip \"ip=${cluster_host_ip_param_ip},cidr_netmask=${cluster_host_ip_param_mask},nic=${cluster_host_ip_interface},arp_count=7,dc=yes\"",
    }
  } else {
    # For ipv6 the only way to initiate outgoing connections
    # over the fixed ips is to set preferred_lft to 0 for the
    # floating ips so that they are not used
    if $::platform::network::cluster_host::params::subnet_version == $::platform::params::ipv6 {
      $preferred_lft_cluster = '0'
    } else {
      $preferred_lft_cluster = 'forever'
    }
    exec { 'Configure Cluster Host IP service instance':
      command =>
          "sm-configure service_instance cluster-host-ip cluster-host-ip \"ip=${cluster_host_ip_param_ip},cidr_netmask=${cluster_host_ip_param_mask},nic=${cluster_host_ip_interface},arp_count=7,preferred_lft=${preferred_lft_cluster}\"",
    }
  }

  exec { 'Configure sm server and client port':
      command => "sm-configure system --sm_client_port=${sm_client_port} --sm_server_port=${sm_server_port}",
  }

  # Create the PXEBoot IP service if it is configured
  if str2bool($::is_initial_config) {
      exec { 'Configure PXEBoot IP service in SM (service-group-member pxeboot-ip)':
          command => 'sm-provision service-group-member controller-services pxeboot-ip',
      }
      -> exec { 'Configure PXEBoot IP service in SM (service pxeboot-ip)':
          command => 'sm-provision service pxeboot-ip',
      }
  }

  if $system_mode == 'duplex-direct' or $system_mode == 'simplex' {
      exec { 'Configure PXEBoot IP':
          command => "sm-configure service_instance pxeboot-ip pxeboot-ip \"ip=${pxeboot_ip_param_ip},cidr_netmask=${pxeboot_ip_param_mask},nic=${pxeboot_ip_interface},arp_count=7,dc=yes\"",
      }
  } else {
      exec { 'Configure PXEBoot IP':
          command => "sm-configure service_instance pxeboot-ip pxeboot-ip \"ip=${pxeboot_ip_param_ip},cidr_netmask=${pxeboot_ip_param_mask},nic=${pxeboot_ip_interface},arp_count=7\"",
      }
  }

  # Create the Ironic IP service if it is configured
  if $ironic_ip_interface and $system_mode != 'simplex' {
      exec { 'Configure Ironic IP service in SM (service-group-member ironic-ip)':
          command => 'sm-provision service-group-member controller-services ironic-ip',
      }
      -> exec { 'Configure Ironic IP service in SM (service ironic-ip)':
          command => 'sm-provision service ironic-ip',
      }
      -> exec { 'Configure Ironic IP':
          command => "sm-configure service_instance ironic-ip ironic-ip \"ip=${ironic_ip_param_ip},cidr_netmask=${ironic_ip_param_mask},nic=${ironic_ip_interface},arp_count=7\"",
      }
  }

  exec { 'Configure Postgres DRBD':
    command => "sm-configure service_instance drbd-pg drbd-pg:${hostunit} \"drbd_resource=${pg_drbd_resource}\"",
  }

  exec { 'Configure Postgres FileSystem':
    command => "sm-configure service_instance pg-fs pg-fs \"device=${pg_fs_device},directory=${pg_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  exec { 'Configure Postgres':
    command => "sm-configure service_instance postgres postgres \"pgctl=/usr/bin/pg_ctl,pgdata=${pg_data_dir}\"",
  }

  exec { 'Configure Rabbit DRBD':
    command => "sm-configure service_instance drbd-rabbit drbd-rabbit:${hostunit} \"drbd_resource=${rabbit_drbd_resource}\"",
  }

  exec { 'Configure Rabbit FileSystem':
    command => "sm-configure service_instance rabbit-fs rabbit-fs \"device=${rabbit_fs_device},directory=${rabbit_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  exec { 'Configure Rabbit':
    command => "sm-configure service_instance rabbit rabbit \"server=${rabbitmq_server},ctl=${rabbitmqctl},pid_file=${rabbit_pid},nodename=${rabbit_node_name},mnesia_base=${rabbit_mnesia_base},ip=${mgmt_ip_param_ip}\"",
  }

  exec { 'Provision Docker Distribution FS in SM (service-group-member dockerdistribution-fs)':
    command => 'sm-provision service-group-member controller-services dockerdistribution-fs',
  }
  -> exec { 'Provision Docker Distribution FS in SM (service dockerdistribution-fs)':
    command => 'sm-provision service dockerdistribution-fs',
  }
  -> exec { 'Provision Docker Distribution DRBD in SM (service-group-member drbd-dockerdistribution)':
    command => 'sm-provision service-group-member controller-services drbd-dockerdistribution',
  }
  -> exec { 'Provision Docker Distribution DRBD in SM (service drbd-dockerdistribution)':
    command => 'sm-provision service drbd-dockerdistribution',
  }
  -> exec { 'Configure Docker Distribution DRBD':
    command => "sm-configure service_instance drbd-dockerdistribution drbd-dockerdistribution:${hostunit} \"drbd_resource=${dockerdistribution_drbd_resource}\"",
  }
  -> exec { 'Configure Docker Distribution FileSystem':
    command => "sm-configure service_instance dockerdistribution-fs dockerdistribution-fs \"device=${dockerdistribution_fs_device},directory=${dockerdistribution_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  exec { 'Configure Extension DRBD':
    command => "sm-configure service_instance drbd-extension drbd-extension:${hostunit} \"drbd_resource=${extension_drbd_resource}\"",
  }

  exec { 'Configure Extension FileSystem':
    command => "sm-configure service_instance extension-fs extension-fs \"device=${extension_fs_device},directory=${extension_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  exec { 'Configure Extension Export FileSystem':
    command => "sm-configure service_instance extension-export-fs extension-export-fs \"fsid=1,directory=${extension_fs_directory},options=rw,sync,no_root_squash,no_subtree_check,clientspec=${platform_nfs_subnet_url},unlock_on_stop=true\"",
  }

  if $drbd_patch_enabled {
    exec { 'Configure DC-vault DRBD':
      command => "sm-configure service_instance drbd-dc-vault drbd-dc-vault:${hostunit} \"drbd_resource=${patch_drbd_resource}\"",
    }

    exec { 'Configure DC-vault FileSystem':
      command => "sm-configure service_instance dc-vault-fs dc-vault-fs \"device=${patch_fs_device},directory=${patch_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
    }
  }

  # Configure helm chart repository
  exec { 'Provision Helm Chart Repository FS in SM (service-group-member helmrepository-fs)':
    command => 'sm-provision service-group-member controller-services helmrepository-fs',
  }
  -> exec { 'Provision Helm Chart Repository FS in SM (service helmrepository-fs)':
    command => 'sm-provision service helmrepository-fs',
  }
  -> exec { 'Configure Helm Chart Repository FileSystem':
    command => "sm-configure service_instance helmrepository-fs helmrepository-fs \"device=${helmrepo_fs_source_dir},directory=${helmrepo_fs_target_dir},options=bind,noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  exec { 'Configure ETCD DRBD':
    command => "sm-configure service_instance drbd-etcd drbd-etcd:${hostunit} drbd_resource=${etcd_drbd_resource}",
  }

  exec { 'Configure ETCD DRBD FileSystem':
    command => "sm-configure service_instance etcd-fs etcd-fs \"device=${etcd_fs_device},directory=${etcd_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  # Configure device image repository
  exec { 'Provision device-image-fs (service-group-member)':
    command => 'sm-provision service-group-member controller-services device-image-fs',
  }
  -> exec { 'Provision device-image-fs (service)':
    command => 'sm-provision service device-image-fs',
  }
  -> exec { 'Configure Device Image Repository FileSystem':
    command => "sm-configure service_instance device-image-fs device-image-fs \"device=${deviceimage_fs_source_dir},directory=${deviceimage_fs_target_dir},options=bind,noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  # TODO: region code needs to be revisited
  if $region_config {
    # In a default Multi-Region configuration, Keystone is running as a
    # shared service in the Primary Region so need to deprovision that
    # service in all non-Primary Regions.
    # However in the case of Distributed Cloud Multi-Region configuration,
    # each Subcloud is running its own Keystone
    if $::platform::params::distributed_cloud_role =='subcloud' {
      $configure_keystone = true

      # Provision and configure dcorch dbsync when running as a subcloud
      exec { 'Provision distributed-cloud-services (service-domain-member distributed-cloud-services)':
        command => 'sm-provision service-domain-member controller distributed-cloud-services',
      }
      -> exec { 'Provision distributed-cloud-services (service-group distributed-cloud-services)':
        command => 'sm-provision service-group distributed-cloud-services',
      }
      -> exec { 'Provision DCDBsync-RestApi (service-group-member dcdbsync-api)':
        command => 'sm-provision service-group-member distributed-cloud-services dcdbsync-api',
      }
      -> exec { 'Provision DCDBsync-RestApi in SM (service dcdbsync-api)':
        command => 'sm-provision service dcdbsync-api',
      }
      -> exec { 'Configure OpenStack - DCDBsync-API':
        command => "sm-configure service_instance dcdbsync-api dcdbsync-api \"\"",
      }
      -> exec { 'Configure OpenStack - DCDBsync-openstack-API':
        command => "sm-configure service_instance dcdbsync-openstack-api dcdbsync-openstack-api \"config=/etc/dcdbsync/dcdbsync_openstack.conf\"",
      }
      # Deprovision Horizon when running as a subcloud
      exec { 'Deprovision OpenStack - Horizon (service-group-member)':
        command => 'sm-deprovision service-group-member web-services horizon',
      }
      -> exec { 'Deprovision OpenStack - Horizon (service)':
        command => 'sm-deprovision service horizon',
      }

    } else {
      exec { 'Deprovision OpenStack - Keystone (service-group-member)':
        command => 'sm-deprovision service-group-member cloud-services keystone',
      }
      -> exec { 'Deprovision OpenStack - Keystone (service)':
        command => 'sm-deprovision service keystone',
      }
      $configure_keystone = false
    }
  } else {
      $configure_keystone = true
  }

  if $configure_keystone {
    exec { 'Configure OpenStack - Keystone':
        command => "sm-configure service_instance keystone keystone \"config=/etc/keystone/keystone.conf,user=root,os_username=${os_username},os_project_name=${os_project_name},os_user_domain_name=${os_user_domain_name},os_project_domain_name=${os_project_domain_name},os_auth_url=${os_auth_url}, \"",
    }
  }

  # Barbican
  exec { 'Configure OpenStack - Barbican API':
    command => "sm-configure service_instance barbican-api barbican-api \"config=/etc/barbican/barbican.conf\"",
  }

  exec { 'Configure OpenStack - Barbican Keystone Listener':
    command => "sm-configure service_instance barbican-keystone-listener barbican-keystone-listener \"config=/etc/barbican/barbican.conf\"",
  }

  exec { 'Configure OpenStack - Barbican Worker':
    command => "sm-configure service_instance barbican-worker barbican-worker \"config=/etc/barbican/barbican.conf\"",
  }

  exec { 'Configure NFS Management':
    command => "sm-configure service_instance nfs-mgmt nfs-mgmt \"exports=${nfs_server_mgmt_exports},mounts=${nfs_server_mgmt_mounts}\"",
  }

  exec { 'Configure Platform DRBD':
    command => "sm-configure service_instance drbd-platform drbd-platform:${hostunit} \"drbd_resource=${platform_drbd_resource}\"",
  }

  exec { 'Configure Platform FileSystem':
    command => "sm-configure service_instance platform-fs platform-fs \"device=${platform_fs_device},directory=${platform_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
  }

  exec { 'Configure Platform Export FileSystem':
    command => "sm-configure service_instance platform-export-fs platform-export-fs \"fsid=0,directory=${platform_fs_directory},options=rw,sync,no_root_squash,no_subtree_check,clientspec=${platform_nfs_subnet_url},unlock_on_stop=true\"",
  }

  # etcd
  exec { 'Configure ETCD':
    command => "sm-configure service_instance etcd etcd \"config=/etc/etcd/etcd.conf,user=root\"",
  }

  # Docker Distribution
  exec { 'Configure Docker Distribution':
    command => "sm-configure service_instance docker-distribution docker-distribution \"\"",
  }

  # Docker Registry Token Server
  exec { 'Configure Docker Registry Token Server':
    command => "sm-configure service_instance registry-token-server registry-token-server \"\"",
  }

  if $system_mode == 'duplex-direct' or $system_mode == 'simplex' {
      exec { 'Configure Platform NFS':
        command => "sm-configure service_instance platform-nfs-ip platform-nfs-ip \"ip=${platform_nfs_ip_param_ip},cidr_netmask=${platform_nfs_ip_param_mask},nic=${mgmt_ip_interface},arp_count=7,dc=yes\"",
      }
  } else {
      exec { 'Configure Platform NFS':
        command => "sm-configure service_instance platform-nfs-ip platform-nfs-ip \"ip=${platform_nfs_ip_param_ip},cidr_netmask=${platform_nfs_ip_param_mask},nic=${mgmt_ip_interface},arp_count=7,preferred_lft=${preferred_lft}\"",
      }
  }

  exec { 'Configure System Inventory API':
    command => "sm-configure service_instance sysinv-inv sysinv-inv \"dbg=false,os_username=${os_username},os_project_name=${os_project_name},os_user_domain_name=${os_user_domain_name},os_project_domain_name=${os_project_domain_name},os_auth_url=${os_auth_url},os_region_name=${os_region_name},system_url=${system_url}\"",
  }

  exec { 'Configure System Inventory Conductor':
    command => "sm-configure service_instance sysinv-conductor sysinv-conductor \"dbg=false\"",
  }

  exec { 'Configure Maintenance Agent':
    command => "sm-configure service_instance mtc-agent mtc-agent \"state=active,logging=true,mode=normal,dbg=false\"",
  }

  exec { 'Configure DNS Mask':
    command => "sm-configure service_instance dnsmasq dnsmasq \"\"",
  }

  exec { 'Configure Fault Manager':
    command => "sm-configure service_instance fm-mgr fm-mgr \"\"",
  }

  exec { 'Configure Open LDAP':
    command => "sm-configure service_instance open-ldap open-ldap \"\"",
  }

  if $system_mode == 'duplex-direct' or $system_mode == 'duplex' {
      exec { 'Configure System Mode':
      command => "sm-configure system --cpe_mode ${system_mode}",
    }

  }

  if $system_mode == 'simplex' {
    exec { 'Configure oam-service redundancy model':
      command => "sm-configure service_group yes controller oam-services N 1 0 \"\" directory-services",
    }

    exec { 'Configure controller-services redundancy model':
      command => "sm-configure service_group yes controller controller-services N 1 0 \"\" directory-services",
    }

    exec { 'Configure cloud-services redundancy model':
      command => "sm-configure service_group yes controller cloud-services N 1 0 \"\" directory-services",
    }

    exec { 'Configure vim-services redundancy model':
      command => "sm-configure service_group yes controller vim-services N 1 0 \"\" directory-services",
    }

    exec { 'Configure patching-services redundancy model':
      command => "sm-configure service_group yes controller patching-services N 1 0 \"\" \"\"",
    }

    exec { 'Configure directory-services redundancy model':
      command => "sm-configure service_group yes controller directory-services N 1 0 \"\" \"\"",
    }

    exec { 'Configure web-services redundancy model':
      command => "sm-configure service_group yes controller web-services N 1 0 \"\" \"\"",
    }

    exec { 'Configure storage-services redundancy model':
      command => "sm-configure service_group yes controller storage-services N 1 0 \"\" \"\"",
    }

    exec { 'Configure storage-monitoring-services redundancy model':
      command => "sm-configure service_group yes controller storage-monitoring-services N 1 0 \"\" \"\"",
    }

    if $::platform::params::distributed_cloud_role == 'subcloud' {
        exec { 'Configure distributed-cloud-services redundancy model':
            command => "sm-configure service_group yes controller distributed-cloud-services N 1 0 \"\" \"\"",
        }
    }
  } else {
    exec { 'Provision oam-ip service group member':
      command => 'sm-provision service-group-member oam-services oam-ip',
    }
    -> exec { 'Provision oam-ip service':
      command => 'sm-provision service oam-ip',
    }

    exec { 'Configure oam-service redundancy model to DX':
      command => "sm-configure service_group yes controller oam-services 'N + M' 1 1 \"\" directory-services",
    }

    exec { 'Configure controller-services redundancy model to DX':
      command => "sm-configure service_group yes controller controller-services 'N + M' 1 1 \"\" directory-services",
    }

    exec { 'Configure cloud-services redundancy model to DX':
      command => "sm-configure service_group yes controller cloud-services 'N + M' 1 1 \"\" directory-services",
    }

    exec { 'Configure vim-services redundancy model to DX':
      command => "sm-configure service_group yes controller vim-services 'N + M' 1 1 \"\" directory-services",
    }

    exec { 'Configure patching-services redundancy model to DX':
      command => "sm-configure service_group yes controller patching-services 'N + M' 1 1 \"\" \"\"",
    }

    exec { 'Configure directory-services redundancy model to DX':
      command => "sm-configure service_group yes controller directory-services N 2 0 \"\" \"\"",
    }

    exec { 'Configure web-services redundancy model to DX':
      command => "sm-configure service_group yes controller web-services N 2 0 \"\" \"\"",
    }

    exec { 'Configure storage-services redundancy model to DX':
      command => "sm-configure service_group yes controller storage-services N 2 0 \"\" \"\"",
    }

    exec { 'Configure storage-monitoring-services redundancy model to DX':
      command => "sm-configure service_group yes controller storage-monitoring-services 'N + M' 1 1 \"\" \"\"",
    }

    if $::platform::params::distributed_cloud_role == 'subcloud' {
        exec { 'Configure distributed-cloud-services redundancy model to DX':
            command => "sm-configure service_group yes controller distributed-cloud-services 'N + M' 1 1 \"\" \"\"",
        }
    }
  }

  exec { 'Provision extension-fs (service-group-member)':
    command => 'sm-provision service-group-member controller-services  extension-fs',
  }
  -> exec { 'Provision extension-fs (service)':
    command => 'sm-provision service extension-fs',
  }
  -> exec { 'Provision drbd-extension (service-group-member)':
    command => 'sm-provision service-group-member controller-services drbd-extension',
  }
  -> exec { 'Provision drbd-extension (service)':
    command => 'sm-provision service drbd-extension',
  }
  -> exec { 'Provision extension-export-fs  (service-group-member)':
    command => 'sm-provision service-group-member controller-services extension-export-fs',
  }
  -> exec { 'Provision extension-export-fs (service)':
    command => 'sm-provision service extension-export-fs',
  }

  if $drbd_patch_enabled {
    exec { 'Provision dc-vault-fs (service-group-member)':
      command => 'sm-provision service-group-member controller-services  dc-vault-fs',
    }
    -> exec { 'Provision dc-vault-fs (service)':
      command => 'sm-provision service dc-vault-fs',
    }
    -> exec { 'Provision drbd-dc-vault (service-group-member)':
      command => 'sm-provision service-group-member controller-services drbd-dc-vault',
    }
    -> exec { 'Provision drbd-dc-vault (service)':
      command => 'sm-provision service drbd-dc-vault',
    }
  }

  # Configure ETCD for Kubernetes
  exec { 'Provision etcd-fs (service-group-member)':
    command => 'sm-provision service-group-member controller-services etcd-fs',
  }
  -> exec { 'Provision etcd-fs (service)':
    command => 'sm-provision service etcd-fs',
  }
  -> exec { 'Provision drbd-etcd (service-group-member)':
    command => 'sm-provision service-group-member controller-services drbd-etcd',
  }
  -> exec { 'Provision drbd-etcd (service)':
    command => 'sm-provision service drbd-etcd',
  }
  -> exec { 'Provision ETCD (service-group-member)':
      command => 'sm-provision service-group-member controller-services etcd',
  }
  -> exec { 'Provision ETCD (service)':
    command => 'sm-provision service etcd',
  }

  if $stx_openstack_applied {
    # Configure dbmon for AIO duplex and systemcontroller
    if ($::platform::params::distributed_cloud_role =='systemcontroller') or
      ($system_type == 'All-in-one' and 'duplex' in $system_mode) {
        exec { 'provision service group member':
            command => 'sm-provision service-group-member cloud-services dbmon --apply'
        }
    }
    exec { 'provision guest-agent service group member':
        command => 'sm-provision service-group-member controller-services guest-agent --apply'
    }
  } else {
    exec { 'deprovision service group member':
        command => 'sm-deprovision service-group-member cloud-services dbmon --apply'
    }
    exec { 'deprovision guest-agent service group member':
        command => 'sm-deprovision service-group-member controller-services guest-agent --apply'
    }
  }

  # Configure Docker Distribution
  exec { 'Provision Docker Distribution (service-group-member)':
      command => 'sm-provision service-group-member controller-services docker-distribution',
  }
  -> exec { 'Provision Docker Distribution (service)':
    command => 'sm-provision service docker-distribution',
  }

  # Configure Docker Registry Token Server
  exec { 'Provision Docker Registry Token Server (service-group-member)':
      command => 'sm-provision service-group-member controller-services registry-token-server',
  }
  -> exec { 'Provision Docker Registry Token Server (service)':
    command => 'sm-provision service registry-token-server',
  }

  # Even when ceph is not configured, service domain members must be present
  # because we can't configure them at runtime.
  exec { 'Provision (service-domain-member storage-services)':
    command => 'sm-provision service-domain-member controller storage-services',
  }
  -> exec { 'Provision (service-group storage-services)':
    command => 'sm-provision service-group storage-services',
  }
  -> exec { 'Provision (service-domain-member storage-monitoring-services':
    command => 'sm-provision service-domain-member controller storage-monitoring-services',
  }
  -> exec { 'Provision service-group storage-monitoring-services':
    command => 'sm-provision service-group storage-monitoring-services',
  }
  -> exec { 'Provision cert-mon service in controller-services group':
    command => 'sm-provision service-group-member controller-services cert-mon'
  }


  # On an AIO-DX system, cephmon DRBD must always be configured, even
  # if ceph is not enabled. Configured, but not enabled services have
  # no impact on the system
  if $system_type == 'All-in-one' and 'duplex' in $system_mode {
    Exec['Provision service-group storage-monitoring-services']
    -> exec { 'Configure Cephmon DRBD':
      command => "sm-configure service_instance drbd-cephmon drbd-cephmon:${hostunit} \"drbd_resource=${cephmon_drbd_resource}\"",
    }
    -> exec { 'Configure Cephmon FileSystem':
      command => "sm-configure service_instance cephmon-fs cephmon-fs \"device=${cephmon_fs_device},directory=${cephmon_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
    }
    -> exec { 'Configure cephmon':
      command => "sm-configure service_instance ceph-mon ceph-mon \"\"",
    }
    -> exec { 'Configure ceph-osd':
      command => "sm-configure service_instance ceph-osd ceph-osd \"\"",
    }

    Exec['Provision service-group storage-monitoring-services']
    -> exec { 'Configure Rookmon DRBD':
      command => "sm-configure service_instance drbd-rookmon drbd-rookmon:${hostunit} \"drbd_resource=${rookmon_drbd_resource}\"",
    }
    -> exec { 'Configure Rookmon FileSystem':
      command => "sm-configure service_instance rookmon-fs rookmon-fs \"device=${rookmon_fs_device},directory=${rookmon_fs_directory},options=noatime,nodiratime,fstype=ext4,check_level=20\"",
    }
    -> exec { 'Configure Rook mon exit':
      command => "sm-configure service_instance rook-mon-exit rook-mon-exit \"\"",
    }
  }


  # Barbican
  exec { 'Provision OpenStack - Barbican API (service-group-member)':
    command => 'sm-provision service-group-member cloud-services barbican-api',
      }
  -> exec { 'Provision OpenStack - Barbican API (service)':
    command => 'sm-provision service barbican-api',
  }
  -> exec { 'Provision OpenStack - Barbican Keystone Listener (service-group-member)':
    command => 'sm-provision service-group-member cloud-services barbican-keystone-listener',
  }
  -> exec { 'Provision OpenStack - Barbican Keystone Listener (service)':
    command => 'sm-provision service barbican-keystone-listener',
      }
  -> exec { 'Provision OpenStack - Barbican Worker (service-group-member)':
    command => 'sm-provision service-group-member cloud-services barbican-worker',
      }
  -> exec { 'Provision OpenStack - Barbican Worker (service)':
    command => 'sm-provision service barbican-worker',
  }

  if $ceph_configured {
    if $system_type == 'All-in-one' and 'duplex' in $system_mode {
      Exec['Configure ceph-osd']
      -> exec { 'Provision Cephmon FS in SM (service-group-member cephmon-fs)':
        command => 'sm-provision service-group-member controller-services cephmon-fs',
      }
      -> exec { 'Provision Cephmon DRBD in SM (service-group-member drbd-cephmon':
        command => 'sm-provision service-group-member controller-services drbd-cephmon',
      }
      -> exec { 'Provision cephmon (service-group-member)':
        command => 'sm-provision service-group-member controller-services ceph-mon',
      }
      -> exec { 'Provision ceph-osd (service-group-member)':
        command => 'sm-provision service-group-member storage-services ceph-osd',
      }
    }

    # Ceph mgr RESTful plugin
    exec { 'Provision mgr-restful-plugin (service-group-member mgr-restful-plugin)':
      command => 'sm-provision service-group-member storage-services mgr-restful-plugin',
    }
    -> exec { 'Provision mgr-restful-plugin (service mgr-restful-plugin)':
      command => 'sm-provision service mgr-restful-plugin',
    }

    # Ceph-Manager
    -> exec { 'Provision Ceph-Manager (service-group-member ceph-manager)':
      command => 'sm-provision service-group-member storage-monitoring-services ceph-manager',
    }
    -> exec { 'Provision Ceph-Manager in SM (service ceph-manager)':
      command => 'sm-provision service ceph-manager',
    }
  }

  if $rook_configured {
    if $system_type == 'All-in-one' and 'duplex' in $system_mode {
      exec { 'Provision Rookmon FS in SM (service-group-member rookmon-fs)':
        command => 'sm-provision service-group-member controller-services rookmon-fs',
      }
      -> exec { 'Provision Rookmon DRBD in SM (service-group-member drbd-rookmon)':
        command => 'sm-provision service-group-member controller-services drbd-rookmon',
      }
      -> exec { 'Provision Rook-mon-exit in SM (service-group-member rook-mon-exit)':
        command => 'sm-provision service-group-member controller-services rook-mon-exit',
      }
    }
  }

  # Ceph-Rados-Gateway
  if $rgw_configured {
    exec {'Provision Ceph-Rados-Gateway (service-group-member ceph-radosgw)':
      command => 'sm-provision service-group-member storage-monitoring-services ceph-radosgw'
    }
    -> exec { 'Provision Ceph-Rados-Gateway (service ceph-radosgw)':
      command => 'sm-provision service ceph-radosgw',
    }
  } else {
    exec {'Deprovision Ceph-Rados-Gateway (service-group-member ceph-radosgw)':
      command => 'sm-deprovision service-group-member storage-monitoring-services ceph-radosgw'
    }
    -> exec { 'Deprovision Ceph-Rados-Gateway (service ceph-radosgw)':
      command => 'sm-deprovision service ceph-radosgw',
    }
  }

  if $ldapserver_remote {
    # if remote LDAP server is configured, deprovision local openldap service.
    exec { 'Deprovision open-ldap service group member':
      command => '/usr/bin/sm-deprovision service-group-member directory-services open-ldap',
    }
    -> exec { 'Deprovision open-ldap service':
      command => '/usr/bin/sm-deprovision service open-ldap',
    }
  }

  if $::platform::params::distributed_cloud_role == 'systemcontroller' {
    include ::platform::dcmanager::params
    $iso_fs_source_dir = $::platform::dcmanager::params::iso_base_dir_source
    $iso_fs_target_dir = $::platform::dcmanager::params::iso_base_dir_target

    exec { 'Provision distributed-cloud-services (service-domain-member distributed-cloud-services)':
      command => 'sm-provision service-domain-member controller distributed-cloud-services',
    }
    -> exec { 'Provision distributed-cloud-services (service-group distributed-cloud-services)':
      command => 'sm-provision service-group distributed-cloud-services',
    }
    -> exec { 'Provision DCManager-Manager (service-group-member dcmanager-manager)':
      command => 'sm-provision service-group-member distributed-cloud-services dcmanager-manager',
    }
    -> exec { 'Provision DCManager-Manager in SM (service dcmanager-manager)':
      command => 'sm-provision service dcmanager-manager',
    }
    -> exec { 'Provision DCManager-Audit (service-group-member dcmanager-audit)':
      command => 'sm-provision service-group-member distributed-cloud-services dcmanager-audit',
    }
    -> exec { 'Provision DCManager-Audit in SM (service dcmanager-audit)':
      command => 'sm-provision service dcmanager-audit',
    }
    -> exec { 'Provision DCManager-Audit-Worker (service-group-member dcmanager-audit-worker)':
      command => 'sm-provision service-group-member distributed-cloud-services dcmanager-audit-worker',
    }
    -> exec { 'Provision DCManager-Audit-Worker in SM (service dcmanager-audit-worker)':
      command => 'sm-provision service dcmanager-audit-worker',
    }
    -> exec { 'Provision DCManager-Orchestrator (service-group-member dcmanager-orchestrator)':
      command => 'sm-provision service-group-member distributed-cloud-services dcmanager-orchestrator',
    }
    -> exec { 'Provision DCManager-Orchestrator in SM (service dcmanager-orchestrator)':
      command => 'sm-provision service dcmanager-orchestrator',
    }
    -> exec { 'Provision DCManager-RestApi (service-group-member dcmanager-api)':
      command => 'sm-provision service-group-member distributed-cloud-services dcmanager-api',
    }
    -> exec { 'Provision DCManager-RestApi in SM (service dcmanager-api)':
      command => 'sm-provision service dcmanager-api',
    }
    -> exec { 'Provision DCOrch-Engine (service-group-member dcorch-engine)':
      command => 'sm-provision service-group-member distributed-cloud-services dcorch-engine',
    }
    -> exec { 'Provision DCOrch-Engine in SM (service dcorch-engine)':
      command => 'sm-provision service dcorch-engine',
    }
    -> exec { 'Provision DCOrch-Identity-Api-Proxy (service-group-member dcorch-identity-api-proxy)':
      command => 'sm-provision service-group-member distributed-cloud-services dcorch-identity-api-proxy',
    }
    -> exec { 'Provision DCOrch-Identity-Api-Proxy in SM (service dcorch-identity-api-proxy)':
      command => 'sm-provision service dcorch-identity-api-proxy',
    }
    -> exec { 'Provision DCOrch-Sysinv-Api-Proxy (service-group-member dcorch-sysinv-api-proxy)':
      command => 'sm-provision service-group-member distributed-cloud-services dcorch-sysinv-api-proxy',
    }
    -> exec { 'Provision DCOrch-Sysinv-Api-Proxy in SM (service dcorch-sysinv-api-proxy)':
      command => 'sm-provision service dcorch-sysinv-api-proxy',
    }
    -> exec { 'Provision DCOrch-Patch-Api-Proxy (service-group-member dcorch-patch-api-proxy)':
      command => 'sm-provision service-group-member distributed-cloud-services dcorch-patch-api-proxy',
    }
    -> exec { 'Provision DCOrch-Patch-Api-Proxy in SM (service dcorch-patch-api-proxy)':
      command => 'sm-provision service dcorch-patch-api-proxy',
    }
    -> exec { 'Provision DCDBsync-RestApi (service-group-member dcdbsync-api)':
      command => 'sm-provision service-group-member distributed-cloud-services dcdbsync-api',
    }
    -> exec { 'Provision DCDBsync-RestApi in SM (service dcdbsync-api)':
      command => 'sm-provision service dcdbsync-api',
    }
    -> exec { 'Provision DC ISO image FS (service-group-member dc-iso-fs)':
      command => 'sm-provision service-group-member distributed-cloud-services dc-iso-fs',
    }
    -> exec { 'Provision DC ISO image FS in SM (service dc-iso-fs)':
      command => 'sm-provision service dc-iso-fs',
    }
    -> exec { 'Configure Platform - DCManager-Manager':
      command => "sm-configure service_instance dcmanager-manager dcmanager-manager \"\"",
    }
    -> exec { 'Configure Platform - DCManager-Audit':
      command => "sm-configure service_instance dcmanager-audit dcmanager-audit \"\"",
    }
    -> exec { 'Configure Platform - DCManager-Audit-Worker':
      command => "sm-configure service_instance dcmanager-audit-worker dcmanager-audit-worker \"\"",
    }
    -> exec { 'Configure Platform - DCManager-Orchestrator':
      command => "sm-configure service_instance dcmanager-orchestrator dcmanager-orchestrator \"\"",
    }
    -> exec { 'Configure OpenStack - DCManager-API':
      command => "sm-configure service_instance dcmanager-api dcmanager-api \"\"",
    }
    -> exec { 'Configure OpenStack - DCOrch-Engine':
      command => "sm-configure service_instance dcorch-engine dcorch-engine \"\"",
    }
    -> exec { 'Configure OpenStack - DCOrch-identity-api-proxy':
      command => "sm-configure service_instance dcorch-identity-api-proxy dcorch-identity-api-proxy \"\"",
    }
    -> exec { 'Configure OpenStack - DCOrch-sysinv-api-proxy':
      command => "sm-configure service_instance dcorch-sysinv-api-proxy dcorch-sysinv-api-proxy \"\"",
    }
    -> exec { 'Configure OpenStack - DCOrch-patch-api-proxy':
      command => "sm-configure service_instance dcorch-patch-api-proxy dcorch-patch-api-proxy \"\"",
    }
    -> exec { 'Configure OpenStack - DCDBsync-API':
      command => "sm-configure service_instance dcdbsync-api dcdbsync-api \"\"",
    }
    -> exec { 'Configure OpenStack - DCDBsync-openstack-API':
      command => "sm-configure service_instance dcdbsync-openstack-api dcdbsync-openstack-api \"config=/etc/dcdbsync/dcdbsync_openstack.conf\"",
    }
    -> exec { 'Configure ISO image FileSystem':
      command => "sm-configure service_instance dc-iso-fs dc-iso-fs \"device=${iso_fs_source_dir},directory=${iso_fs_target_dir},options=bind,noatime,nodiratime,fstype=ext4,check_level=20\"",
    }
  }

  # lint:endignore:140chars
}


define platform::sm::restart {
  exec {"sm-restart-${name}":
    command => "sm-restart-safe service ${name}",
  }
}


# WARNING:
# This should only be invoked in a standalone / simplex mode.
# It is currently used during infrastructure network post-install apply
# to ensure SM reloads the updated configuration after the manifests
# are applied.
# Semantic checks enforce the standalone condition (all hosts locked)
class platform::sm::reload {

  # Ensure service(s) are restarted before SM is restarted
  Platform::Sm::Restart <| |> -> Class[$name]

  exec { 'pmon-stop-sm':
    command => 'pmon-stop sm'
  }
  -> file { '/var/run/sm/sm.db':
    ensure => absent
  }
  -> exec { 'pmon-start-sm':
    command => 'pmon-start sm'
  }
}


class platform::sm::norestart::runtime {
  include ::platform::sm
}

class platform::sm::runtime {
  include ::platform::sm

  class { 'platform::sm::reload':
    stage => post,
  }
}

class platform::sm::stx_openstack::runtime {
  include ::platform::params
  $system_type                   = $::platform::params::system_type
  $system_mode                   = $::platform::params::system_mode
  $stx_openstack_applied         = $::platform::params::stx_openstack_applied

  if $stx_openstack_applied {
    # Configure dbmon for AIO duplex and systemcontroller
    if ($::platform::params::distributed_cloud_role == 'systemcontroller') or
      ($system_type == 'All-in-one' and 'duplex' in $system_mode) {
        exec { 'provision service group member':
            command => 'sm-provision service-group-member cloud-services dbmon --apply'
        }
    }
    exec { 'provision guest-agent service group member':
        command => 'sm-provision service-group-member controller-services guest-agent --apply'
    }
    # Configure openstack dcdbsync for systemcontroller and subcloud
    if ($::platform::params::distributed_cloud_role =='systemcontroller') or
      ($::platform::params::distributed_cloud_role =='subcloud') {
        exec { 'provision distributed-cloud service group member':
          command => 'sm-provision service-group-member distributed-cloud-services dcdbsync-openstack-api --apply'
        }
    }
  } else {
    exec { 'deprovision service group member':
        command => 'sm-deprovision service-group-member cloud-services dbmon --apply'
    }
    exec { 'deprovision guest-agent service group member':
        command => 'sm-deprovision service-group-member controller-services guest-agent --apply'
    }
    exec { 'deprovision distributed-cloud service group member':
        command => 'sm-deprovision service-group-member distributed-cloud-services dcdbsync-openstack-api --apply'
    }
    -> exec { 'stop distributed-cloud service group member':
      environment => ['OCF_FUNCTIONS_DIR=/usr/lib/ocf/lib/heartbeat/',
        'OCF_RESKEY_pid=/var/run/resource-agents/dcdbsync-openstack-api.pid'],
      command     => '/usr/lib/ocf/resource.d/openstack/dcdbsync-api stop',
    }
  }

  # Restart dcorch engine for systemcontroller after stx-openstack applied/removed
  # since it's configuration is changed.
  if ($::platform::params::distributed_cloud_role == 'systemcontroller') {
    exec { 'restart distributed-cloud service group member':
        command => 'sm-restart service dcorch-engine'
    }
  }
}

class platform::sm::rgw::runtime {
  $rgw_configured = $::platform::ceph::params::rgw_enabled

  if $rgw_configured {
    exec {'Provision Ceph-Rados-Gateway (service-group-member ceph-radosgw)':
      command => 'sm-provision service-group-member storage-monitoring-services ceph-radosgw --apply'
    }
  } else {
    exec {'Deprovision Ceph-Rados-Gateway (service-group-member ceph-radosgw)':
      command => 'sm-deprovision service-group-member storage-monitoring-services ceph-radosgw --apply'
    }
  }
}

class platform::sm::ceph::runtime {
  $ceph_configured = $::platform::ceph::params::service_enabled
  $rook_configured = $::platform::rook::params::service_enabled
  $system_mode     = $::platform::params::system_mode
  $system_type     = $::platform::params::system_type

  if $ceph_configured {
    Class['::platform::ceph::monitor'] -> Class[$name]
    Class['::platform::ceph'] -> Class[$name]

    if $system_type == 'All-in-one' and 'duplex' in $system_mode {
      exec { 'Provision Cephmon FS in SM --apply (service-group-member cephmon-fs)':
        command => 'sm-provision service-group-member controller-services cephmon-fs --apply',
      }
      -> exec { 'Provision Cephmon DRBD in SM --apply (service-group-member drbd-cephmon':
        command => 'sm-provision service-group-member controller-services drbd-cephmon --apply',
      }
      -> exec { 'Provision cephmon --apply (service-group-member)':
        command => 'sm-provision service-group-member controller-services ceph-mon --apply',
      }
      -> exec { 'Provision ceph-osd --apply (service-group-member)':
        command => 'sm-provision service-group-member storage-services ceph-osd --apply',
      }
    }
    exec { 'Provision mgr-restful-plugin --apply (service-group-member mgr-restful-plugin)':
      command => 'sm-provision service-group-member storage-services mgr-restful-plugin --apply',
    }
    -> exec { 'Provision Ceph-Manager --apply (service-group-member ceph-manager)':
      command => 'sm-provision service-group-member storage-monitoring-services ceph-manager --apply',
    }
  }

  if $rook_configured {
    if $system_type == 'All-in-one' and 'duplex' in $system_mode {
      exec { 'Provision Cephmon FS in SM (service-group-member cephmon-fs)':
        command => 'sm-provision service-group-member controller-services rookmon-fs --apply',
      }
      -> exec { 'Provision Cephmon DRBD in SM (service-group-member drbd-cephmon':
        command => 'sm-provision service-group-member controller-services drbd-rookmon --apply',
      }
      -> exec { 'Provision Rook-mon-exit in SM (service-group-member rook-mon-exit)':
        command => 'sm-provision service-group-member controller-services rook-mon-exit --apply',
      }
    }
  }
}
