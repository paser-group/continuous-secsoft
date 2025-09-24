class platform::kubernetes::params (
  $enabled = true,
  # K8S version we are upgrading to (None if not in an upgrade)
  $upgrade_to_version = undef,
  # K8S version running on a host
  $version = undef,
  $node_ip = undef,
  $service_domain = undef,
  $dns_service_ip = undef,
  $host_labels = [],
  $k8s_cpuset = undef,
  $k8s_nodeset = undef,
  $k8s_platform_cpuset = undef,
  $k8s_reserved_mem = undef,
  $k8s_all_reserved_cpuset = undef,
  $k8s_cpu_mgr_policy = 'none',
  $k8s_topology_mgr_policy = 'best-effort',
  $k8s_cni_bin_dir = '/usr/libexec/cni',
  $k8s_vol_plugin_dir = '/usr/libexec/kubernetes/kubelet-plugins/volume/exec/',
  $join_cmd = undef,
  $oidc_issuer_url = undef,
  $oidc_client_id = undef,
  $oidc_username_claim = undef,
  $oidc_groups_claim = undef,
  $admission_plugins = undef,
  $etcd_cafile = undef,
  $etcd_certfile = undef,
  $etcd_keyfile = undef,
  $etcd_servers = undef,
) { }

class platform::kubernetes::cgroup::params (
  $cgroup_root = '/sys/fs/cgroup',
  $cgroup_name = 'k8s-infra',
  $controllers = ['cpuset', 'cpu', 'cpuacct', 'memory', 'systemd', 'pids'],
) {}

class platform::kubernetes::cgroup
  inherits ::platform::kubernetes::cgroup::params {
  include ::platform::kubernetes::params

  $k8s_cpuset = $::platform::kubernetes::params::k8s_cpuset
  $k8s_nodeset = $::platform::kubernetes::params::k8s_nodeset

  # Default to float across all cpus and numa nodes
  if !defined('$k8s_cpuset') {
    $k8s_cpuset = generate('/bin/cat', '/sys/devices/system/cpu/online')
    notice("System default cpuset ${k8s_cpuset}.")
  }
  if !defined('$k8s_nodeset') {
    $k8s_nodeset = generate('/bin/cat', '/sys/devices/system/node/online')
    notice("System default nodeset ${k8s_nodeset}.")
  }

  # Create kubelet cgroup for the minimal set of required controllers.
  # NOTE: The kubernetes cgroup_manager_linux func Exists() checks that
  # specific subsystem cgroup paths actually exist on the system. The
  # particular cgroup cgroupRoot must exist for the following controllers:
  # "cpu", "cpuacct", "cpuset", "memory", "systemd", "pids".
  # Reference:
  #  https://github.com/kubernetes/kubernetes/blob/master/pkg/kubelet/cm/cgroup_manager_linux.go
  # systemd automatically mounts cgroups and controllers, so don't need
  # to do that here.
  notice("Create ${cgroup_root}/${controllers}/${cgroup_name}")
  $controllers.each |String $controller| {
    $cgroup_dir = "${cgroup_root}/${controller}/${cgroup_name}"
    file { $cgroup_dir :
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }

    # Modify k8s cpuset resources to reflect platform configured cores.
    # NOTE: Using 'exec' here instead of 'file' resource type with 'content'
    # tag to update contents under /sys, since puppet tries to create files
    # with temp names in the same directory, and the kernel only allows
    # specific filenames to be created in these particular directories.
    # This causes puppet to fail if we use the 'content' tag.
    # NOTE: Child cgroups cpuset must be subset of parent. In the case where
    # child directories already exist and we change the parent's cpuset to
    # be a subset of what the children have, will cause the command to fail
    # with "-bash: echo: write error: device or resource busy".
    if $controller == 'cpuset' {
      $cgroup_mems = "${cgroup_dir}/cpuset.mems"
      $cgroup_cpus = "${cgroup_dir}/cpuset.cpus"
      $cgroup_tasks = "${cgroup_dir}/tasks"

      notice("Set ${cgroup_name} nodeset: ${k8s_nodeset}, cpuset: ${k8s_cpuset}")
      File[ $cgroup_dir ]
      -> exec { "Create ${cgroup_mems}" :
        command => "/bin/echo ${k8s_nodeset} > ${cgroup_mems} || :",
      }
      -> exec { "Create ${cgroup_cpus}" :
        command => "/bin/echo ${k8s_cpuset} > ${cgroup_cpus} || :",
      }
      -> file { $cgroup_tasks :
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }
    }
  }
}

class platform::kubernetes::kubeadm {

  include ::platform::docker::params
  include ::platform::kubernetes::params
  include ::platform::params

  $node_ip = $::platform::kubernetes::params::node_ip
  $host_labels = $::platform::kubernetes::params::host_labels
  $k8s_platform_cpuset = $::platform::kubernetes::params::k8s_platform_cpuset
  $k8s_reserved_mem = $::platform::kubernetes::params::k8s_reserved_mem
  $k8s_all_reserved_cpuset = $::platform::kubernetes::params::k8s_all_reserved_cpuset
  $k8s_cni_bin_dir = $::platform::kubernetes::params::k8s_cni_bin_dir
  $k8s_vol_plugin_dir = $::platform::kubernetes::params::k8s_vol_plugin_dir
  $k8s_cpu_mgr_policy = $::platform::kubernetes::params::k8s_cpu_mgr_policy
  $k8s_topology_mgr_policy = $::platform::kubernetes::params::k8s_topology_mgr_policy

  $iptables_file = "net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1"

  # Configure kubelet cpumanager options
  $opts_sys_res = join(['--system-reserved=',
                        "memory=${k8s_reserved_mem}Mi"])

  if ($::personality == 'controller' and
      $::platform::params::distributed_cloud_role == 'systemcontroller') {
    $opts = '--cpu-manager-policy=none'
    $k8s_cpu_manager_opts = join([$opts,
                                  $opts_sys_res], ' ')
  } else {
    if !$::platform::params::virtual_system {
      if str2bool($::is_worker_subfunction)
        and !('openstack-compute-node' in $host_labels) {
        # Enable TopologyManager for hosts with the worker subfunction.
        # Exceptions are:
        #   - DC System controllers
        #   - Virtualized nodes (lab environment only)

        $opts = join(['--feature-gates TopologyManager=true',
                      "--cpu-manager-policy=${k8s_cpu_mgr_policy}",
                      "--topology-manager-policy=${k8s_topology_mgr_policy}"], ' ')

        if $k8s_cpu_mgr_policy == 'none' {
          $k8s_reserved_cpus = $k8s_platform_cpuset
        } else {
          # The union of platform, isolated, and vswitch
          $k8s_reserved_cpus = $k8s_all_reserved_cpuset
        }

        $opts_res_cpus = "--reserved-cpus=${k8s_reserved_cpus}"
        $k8s_cpu_manager_opts = join([$opts,
                                      $opts_sys_res,
                                      $opts_res_cpus], ' ')
      } else {
        $opts = '--cpu-manager-policy=none'
        $k8s_cpu_manager_opts = join([$opts,
                                      $opts_sys_res], ' ')

      }
    } else {
      $k8s_cpu_manager_opts = '--cpu-manager-policy=none'
    }
  }

  # Enable kubelet extra parameters that are node specific such as
  # cpumanager
  file { '/etc/sysconfig/kubelet':
    ensure  => file,
    content => template('platform/kubelet.conf.erb'),
  }
  # The cpu_manager_state file is regenerated when cpumanager starts or
  # changes allocations so it is safe to remove before kubelet starts.
  # This file persists so cpumanager's DefaultCPUSet becomes inconsistent
  # when we offline/online CPUs or change the number of reserved cpus.
  -> exec { 'remove cpu_manager_state':
    command => 'rm -f /var/lib/kubelet/cpu_manager_state || true',
  }

  # Update iptables config. This is required based on:
  # https://kubernetes.io/docs/tasks/tools/install-kubeadm
  # This probably belongs somewhere else - initscripts package?
  file { '/etc/sysctl.d/k8s.conf':
    ensure  => file,
    content => $iptables_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  -> exec { 'update kernel parameters for iptables':
    command => 'sysctl --system',
  }

  # Create manifests directory required by kubelet
  -> file { '/etc/kubernetes/manifests':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  # Start kubelet.
  -> service { 'kubelet':
    enable => true,
  }
  # A seperate enable is required since we have modified the service resource
  # to never enable services.
  -> exec { 'enable-kubelet':
    command => '/usr/bin/systemctl enable kubelet.service',
  }
}

class platform::kubernetes::master::init
  inherits ::platform::kubernetes::params {

  include ::platform::params
  include ::platform::docker::params
  include ::platform::dockerdistribution::params

  if str2bool($::is_initial_k8s_config) {
    # This allows subsequent node installs
    # Notes regarding ::is_initial_k8s_config check:
    # - Ensures block is only run for new node installs (e.g. controller-1)
    #  or reinstalls. This part is needed only once;
    # - Ansible configuration is independently configuring Kubernetes. A retry
    #   in configuration by puppet leads to failed manifest application.
    #   This flag is created by Ansible on controller-0;
    # - Ansible replay is not impacted by flag creation.

    $local_registry_auth = "${::platform::dockerdistribution::params::registry_username}:${::platform::dockerdistribution::params::registry_password}" # lint:ignore:140chars

    exec { 'pre pull k8s images':
      command   => "kubeadm --kubeconfig=/etc/kubernetes/admin.conf config images list --kubernetes-version ${version}  --image-repository registry.local:9001/k8s.gcr.io | xargs -i crictl pull --creds ${local_registry_auth} {}", # lint:ignore:140chars
      logoutput => true,
    }

    -> exec { 'configure master node':
      command   => $join_cmd,
      logoutput => true,
    }

    # Update ownership/permissions for file created by "kubeadm init".
    # We want it readable by sysinv and sysadmin.
    -> file { '/etc/kubernetes/admin.conf':
      ensure => file,
      owner  => 'root',
      group  => $::platform::params::protected_group_name,
      mode   => '0640',
    }

    # Add a bash profile script to set a k8s env variable
    -> file {'bash_profile_k8s':
      ensure => present,
      path   => '/etc/profile.d/kubeconfig.sh',
      mode   => '0644',
      source => "puppet:///modules/${module_name}/kubeconfig.sh"
    }

    # Remove the taint from the master node
    -> exec { 'remove taint from master node':
      command   => "kubectl --kubeconfig=/etc/kubernetes/admin.conf taint node ${::platform::params::hostname} node-role.kubernetes.io/master- || true", # lint:ignore:140chars
      logoutput => true,
    }

    # Add kubelet service override
    -> file { '/etc/systemd/system/kubelet.service.d/kube-stx-override.conf':
      ensure  => file,
      content => template('platform/kube-stx-override.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    # set kubelet monitored by pmond
    -> file { '/etc/pmon.d/kubelet.conf':
      ensure  => file,
      content => template('platform/kubelet-pmond-conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    # Reload systemd
    -> exec { 'perform systemctl daemon reload for kubelet override':
      command   => 'systemctl daemon-reload',
      logoutput => true,
    }

    # Initial kubernetes config done on node
    -> file { '/etc/platform/.initial_k8s_config_complete':
      ensure => present,
    }
  }

  # Run kube-cert-rotation daily
  cron { 'kube-cert-rotation':
    ensure      => 'present',
    command     => '/usr/bin/kube-cert-rotation.sh',
    environment => 'PATH=/bin:/usr/bin:/usr/sbin',
    minute      => '10',
    hour        => '*/24',
    user        => 'root',
  }
}

class platform::kubernetes::master
  inherits ::platform::kubernetes::params {

  contain ::platform::kubernetes::kubeadm
  contain ::platform::kubernetes::cgroup
  contain ::platform::kubernetes::master::init
  contain ::platform::kubernetes::coredns
  contain ::platform::kubernetes::firewall

  Class['::platform::sysctl::controller::reserve_ports'] -> Class[$name]
  Class['::platform::etcd'] -> Class[$name]
  Class['::platform::docker::config'] -> Class[$name]
  Class['::platform::containerd::config'] -> Class[$name]
  # Ensure DNS is configured as name resolution is required when
  # kubeadm init is run.
  Class['::platform::dns'] -> Class[$name]
  Class['::platform::kubernetes::kubeadm']
  -> Class['::platform::kubernetes::cgroup']
  -> Class['::platform::kubernetes::master::init']
  -> Class['::platform::kubernetes::coredns']
  -> Class['::platform::kubernetes::firewall']
}

class platform::kubernetes::worker::init
  inherits ::platform::kubernetes::params {

  Class['::platform::docker::config'] -> Class[$name]
  Class['::platform::containerd::config'] -> Class[$name]
  Class['::platform::filesystem::kubelet'] -> Class[$name]

  if str2bool($::is_initial_config) {
    include ::platform::dockerdistribution::params
    # Pull pause image tag from kubeadm required images list for this version
    # kubeadm config images list does not use the --kubeconfig argument
    # and admin.conf will not exist on a pure worker, and kubelet.conf will not
    # exist until after a join.
    $local_registry_auth = "${::platform::dockerdistribution::params::registry_username}:${::platform::dockerdistribution::params::registry_password}" # lint:ignore:140chars
    exec { 'load k8s pause image by containerd':
      # splitting this command over multiple lines appears to break puppet-lint
      command   => "kubeadm config images list --kubernetes-version ${version} --image-repository=registry.local:9001/k8s.gcr.io 2>/dev/null | grep k8s.gcr.io/pause: | xargs -i crictl pull --creds ${local_registry_auth} {}", # lint:ignore:140chars
      logoutput => true,
      before    => Exec['configure worker node'],
    }
  }

  # Configure the worker node. Only do this once, so check whether the
  # kubelet.conf file has already been created (by the join).
  exec { 'configure worker node':
    command   => $join_cmd,
    logoutput => true,
    unless    => 'test -f /etc/kubernetes/kubelet.conf',
  }

  # Add kubelet service override
  -> file { '/etc/systemd/system/kubelet.service.d/kube-stx-override.conf':
    ensure  => file,
    content => template('platform/kube-stx-override.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # set kubelet monitored by pmond
  -> file { '/etc/pmon.d/kubelet.conf':
    ensure  => file,
    content => template('platform/kubelet-pmond-conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # Reload systemd
  -> exec { 'perform systemctl daemon reload for kubelet override':
    command   => 'systemctl daemon-reload',
    logoutput => true,
  }
}

class platform::kubernetes::worker::pci
(
  $pcidp_resources = undef,
) {
  include ::platform::kubernetes::params
  include ::platform::kubernetes::worker::sriovdp

  file { '/etc/pcidp':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
  -> file { '/etc/pcidp/config.json':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('platform/pcidp.conf.erb'),
  }
}

class platform::kubernetes::worker::pci::runtime {
  include ::platform::kubernetes::worker::pci
}

class platform::kubernetes::worker::sriovdp {
  include ::platform::kubernetes::params
  include ::platform::params
  $host_labels = $::platform::kubernetes::params::host_labels
  if ($::personality == 'controller') and
      str2bool($::is_worker_subfunction)
      and ('sriovdp' in $host_labels) {
    # In an AIO system, it's possible for the device plugin pods to start
    # before the device VFs are bound to a driver.  Deleting the device
    # plugin pods will cause them to be recreated by the daemonset and
    # allow them to re-scan the set of matching device ids/drivers
    # specified in the /etc/pcidp/config.json file.
    # This may be mitigated by moving to helm + configmap for the device
    # plugin.
    exec { 'Delete sriov device plugin pod if present':
      path      => '/usr/bin:/usr/sbin:/bin',
      command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf delete pod -n kube-system --selector=app=sriovdp --field-selector spec.nodeName=$(hostname) --timeout=360s', # lint:ignore:140chars
      onlyif    => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf get pods -n kube-system --selector=app=sriovdp --field-selector spec.nodeName=$(hostname) | grep kube-sriov-device-plugin', # lint:ignore:140chars
      logoutput => true,
    }
  }
}

class platform::kubernetes::worker
  inherits ::platform::kubernetes::params {

  # Worker configuration is not required on AIO hosts, since the master
  # will already be configured and includes support for running pods.
  if $::personality != 'controller' {
    contain ::platform::kubernetes::kubeadm
    contain ::platform::kubernetes::cgroup
    contain ::platform::kubernetes::worker::init

    Class['::platform::kubernetes::kubeadm']
    -> Class['::platform::kubernetes::cgroup']
    -> Class['::platform::kubernetes::worker::init']
  } else {
    # Reconfigure cgroups cpusets on AIO
    contain ::platform::kubernetes::cgroup

    # Add refresh dependency for kubelet for hugepage allocation
    Class['::platform::compute::allocate']
    ~> service { 'kubelet':
    }
  }

  # TODO: The following exec is a workaround. Once kubernetes becomes the
  # default installation, /etc/pmon.d/libvirtd.conf needs to be removed from
  # the load.
  exec { 'Update PMON libvirtd.conf':
    command => "/bin/sed -i 's#mode  = passive#mode  = ignore #' /etc/pmon.d/libvirtd.conf",
    onlyif  => '/usr/bin/test -e /etc/pmon.d/libvirtd.conf'
  }

  contain ::platform::kubernetes::worker::pci
}

class platform::kubernetes::coredns {

  include ::platform::params

  if str2bool($::is_initial_k8s_config) {
    if $::platform::params::system_mode != 'simplex' {
      # For duplex and multi-node system, restrict the dns pod to master nodes
      exec { 'restrict coredns to master nodes':
        command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system patch deployment coredns -p \'{"spec":{"template":{"spec":{"nodeSelector":{"node-role.kubernetes.io/master":""}}}}}\'', # lint:ignore:140chars
        logoutput => true,
      }

      -> exec { 'Use anti-affinity for coredns pods':
        command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system patch deployment coredns -p \'{"spec":{"template":{"spec":{"affinity":{"podAntiAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":[{"labelSelector":{"matchExpressions":[{"key":"k8s-app","operator":"In","values":["kube-dns"]}]},"topologyKey":"kubernetes.io/hostname"}]}}}}}}\'', # lint:ignore:140chars
        logoutput => true,
      }
    } else {
      # For simplex system, 1 coredns is enough
      exec { '1 coredns for simplex mode':
        command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system scale --replicas=1 deployment coredns', # lint:ignore:140chars
        logoutput => true,
      }
    }
  }
}

# TODO: remove port 9001 once we have a public docker image registry using standard ports.
# add 5000 as the default port for private registry
class platform::kubernetes::firewall::params (
  $transport = 'tcp',
  $table = 'nat',
  $dports = [80, 443, 9001, 5000],
  $chain = 'POSTROUTING',
  $jump = 'SNAT',
) {}

class platform::kubernetes::firewall
  inherits ::platform::kubernetes::firewall::params {

  include ::platform::params
  include ::platform::network::oam::params
  include ::platform::network::mgmt::params
  include ::platform::docker::params

  # add http_proxy and https_proxy port to k8s firewall
  # in order to allow worker node access public network via proxy
  if $::platform::docker::params::http_proxy {
    $http_proxy_str_array = split($::platform::docker::params::http_proxy, ':')
    $http_proxy_port = $http_proxy_str_array[length($http_proxy_str_array) - 1]
    if $http_proxy_port =~ /^\d+$/ {
      $http_proxy_port_val = $http_proxy_port
    }
  }

  if $::platform::docker::params::https_proxy {
    $https_proxy_str_array = split($::platform::docker::params::https_proxy, ':')
    $https_proxy_port = $https_proxy_str_array[length($https_proxy_str_array) - 1]
    if $https_proxy_port =~ /^\d+$/ {
      $https_proxy_port_val = $https_proxy_port
    }
  }

  if defined('$http_proxy_port_val') {
    if defined('$https_proxy_port_val') and ($http_proxy_port_val != $https_proxy_port_val) {
      $dports = $dports << $http_proxy_port_val << $https_proxy_port_val
    } else {
      $dports = $dports << $http_proxy_port_val
    }
  } elsif defined('$https_proxy_port_val') {
    $dports = $dports << $https_proxy_port_val
  }

  $system_mode = $::platform::params::system_mode
  $oam_float_ip = $::platform::network::oam::params::controller_address
  $oam_interface = $::platform::network::oam::params::interface_name
  $mgmt_subnet = $::platform::network::mgmt::params::subnet_network
  $mgmt_prefixlen = $::platform::network::mgmt::params::subnet_prefixlen

  $s_mgmt_subnet = "${mgmt_subnet}/${mgmt_prefixlen}"
  $d_mgmt_subnet = "! ${s_mgmt_subnet}"

  if $system_mode != 'simplex' {
    platform::firewall::rule { 'kubernetes-nat':
      service_name => 'kubernetes',
      table        => $table,
      chain        => $chain,
      proto        => $transport,
      jump         => $jump,
      ports        => $dports,
      host         => $s_mgmt_subnet,
      destination  => $d_mgmt_subnet,
      outiface     => $oam_interface,
      tosource     => $oam_float_ip,
    }
  }
}

class platform::kubernetes::pre_pull_control_plane_images
  inherits ::platform::kubernetes::params {

  include ::platform::dockerdistribution::params

  $local_registry_auth = "${::platform::dockerdistribution::params::registry_username}:${::platform::dockerdistribution::params::registry_password}" # lint:ignore:140chars

  exec { 'pre pull images':
    command   => "kubeadm --kubeconfig=/etc/kubernetes/admin.conf config images list --kubernetes-version ${upgrade_to_version} --image-repository=registry.local:9001/k8s.gcr.io | xargs -i crictl pull --creds ${local_registry_auth} {}", # lint:ignore:140chars
    logoutput => true,
  }
}

class platform::kubernetes::upgrade_first_control_plane
  inherits ::platform::kubernetes::params {

  include ::platform::params

  # The --allow-*-upgrades options allow us to upgrade to any k8s release if necessary
  exec { 'upgrade first control plane':
    command   => "kubeadm --kubeconfig=/etc/kubernetes/admin.conf upgrade apply ${version} --allow-experimental-upgrades --allow-release-candidate-upgrades -y", # lint:ignore:140chars
    logoutput => true,
  }

  if $::platform::params::system_mode != 'simplex' {
    # For duplex and multi-node system, restrict the coredns pod to master nodes
    exec { 'restrict coredns to master nodes':
      command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system patch deployment coredns -p \'{"spec":{"template":{"spec":{"nodeSelector":{"node-role.kubernetes.io/master":""}}}}}\'', # lint:ignore:140chars
      logoutput => true,
      require   => Exec['upgrade first control plane']
    }
    -> exec { 'Use anti-affinity for coredns pods':
      command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system patch deployment coredns -p \'{"spec":{"template":{"spec":{"affinity":{"podAntiAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":[{"labelSelector":{"matchExpressions":[{"key":"k8s-app","operator":"In","values":["kube-dns"]}]},"topologyKey":"kubernetes.io/hostname"}]}}}}}}\'', # lint:ignore:140chars
      logoutput => true,
    }
  } else {
    # For simplex system, 1 coredns is enough
    exec { '1 coredns for simplex mode':
      command   => 'kubectl --kubeconfig=/etc/kubernetes/admin.conf -n kube-system scale --replicas=1 deployment coredns', # lint:ignore:140chars
      logoutput => true,
      require   => Exec['upgrade first control plane']
    }
  }
}

class platform::kubernetes::upgrade_control_plane
  inherits ::platform::kubernetes::params {

  # control plane is only upgraded on a controller (which has admin.conf)
  exec { 'upgrade control plane':
    command   => 'kubeadm --kubeconfig=/etc/kubernetes/admin.conf upgrade node',
    logoutput => true,
  }
}

class platform::kubernetes::master::upgrade_kubelet
  inherits ::platform::kubernetes::params {

  exec { 'restart kubelet':
      command => '/usr/local/sbin/pmon-restart kubelet'
  }
}

class platform::kubernetes::worker::upgrade_kubelet
  inherits ::platform::kubernetes::params {

  include ::platform::dockerdistribution::params

  # workers use kubelet.conf rather than admin.conf
  $local_registry_auth = "${::platform::dockerdistribution::params::registry_username}:${::platform::dockerdistribution::params::registry_password}" # lint:ignore:140chars

  # Pull the pause image tag from kubeadm required images list for this version
  exec { 'pull pause image':
    # spltting this command over multiple lines will break puppet-lint for later violations
    command   => "kubeadm --kubeconfig=/etc/kubernetes/kubelet.conf config images list --kubernetes-version ${upgrade_to_version} --image-repository=registry.local:9001/k8s.gcr.io 2>/dev/null | grep k8s.gcr.io/pause: | xargs -i crictl pull --creds ${local_registry_auth} {}", # lint:ignore:140chars
    logoutput => true,
    before    => Exec['upgrade kubelet'],
  }

  exec { 'upgrade kubelet':
    command   => 'kubeadm --kubeconfig=/etc/kubernetes/kubelet.conf upgrade node',
    logoutput => true,
  }

  -> exec { 'restart kubelet':
      command => '/usr/local/sbin/pmon-restart kubelet'
  }
}

class platform::kubernetes::master::change_apiserver_parameters (
  $etcd_cafile = $platform::kubernetes::params::etcd_cafile,
  $etcd_certfile = $platform::kubernetes::params::etcd_certfile,
  $etcd_keyfile = $platform::kubernetes::params::etcd_keyfile,
  $etcd_servers = $platform::kubernetes::params::etcd_servers,
) inherits ::platform::kubernetes::params {

  $configmap_temp_file = '/tmp/cluster_configmap.yaml'
  $configview_temp_file = '/tmp/kubeadm_config_view.yaml'

  exec { 'update kube-apiserver params':
    command => template('platform/kube-apiserver-change-params.erb')
  }
}

class platform::kubernetes::certsans::runtime
  inherits ::platform::kubernetes::params {
  include ::platform::params
  include ::platform::network::mgmt::params
  include ::platform::network::oam::params
  include ::platform::network::cluster_host::params

  if $::platform::network::mgmt::params::subnet_version == $::platform::params::ipv6 {
    $localhost_address = '::1'
  } else {
    $localhost_address = '127.0.0.1'
  }

  if $::platform::params::system_mode == 'simplex' {
    $certsans = "\"${platform::network::cluster_host::params::controller_address}, \
                   ${localhost_address}, \
                   ${platform::network::oam::params::controller_address}\""
  } else {
    $certsans = "\"${platform::network::cluster_host::params::controller_address}, \
                   ${localhost_address}, \
                   ${platform::network::oam::params::controller_address}, \
                   ${platform::network::oam::params::controller0_address}, \
                   ${platform::network::oam::params::controller1_address}\""
  }

  exec { 'update kube-apiserver certSANs':
    provider => shell,
    command  => template('platform/kube-apiserver-update-certSANs.erb')
  }
}
