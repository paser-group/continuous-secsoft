# Class: fuel_project::jenkins::slave
#
class fuel_project::jenkins::slave (
  $docker_package,
  $ruby_version,
  $bind_policy                          = '',
  $build_fuel_iso                       = false,
  $build_fuel_packages                  = false,
  $build_fuel_npm_packages              = ['grunt-cli', 'gulp'],
  $build_fuel_plugins                   = false,
  $check_tasks_graph                    = false,
  $docker_service                       = '',
  $external_host                        = false,
  $fuel_web_selenium                    = false,
  $http_share_iso                       = false,
  $install_docker                       = false,
  $jenkins_swarm_slave                  = false,
  $known_hosts                          = {},
  $known_hosts_overwrite                = false,
  $libvirt_default_network              = false,
  $ldap                                 = false,
  $ldap_base                            = '',
  $ldap_ignore_users                    = '',
  $ldap_sudo_group                      = undef,
  $ldap_uri                             = '',
  $local_ssh_private_key                = undef,
  $local_ssh_public_key                 = undef,
  $nailgun_db                           = ['nailgun'],
  $osc_apiurl                           = '',
  $osc_pass_primary                     = '',
  $osc_pass_secondary                   = '',
  $osc_url_primary                      = '',
  $osc_url_secondary                    = '',
  $osc_user_primary                     = '',
  $osc_user_secondary                   = '',
  $osci_centos_image_name               = 'centos6.4-x86_64-gold-master.img',
  $osci_centos_job_dir                  = '/home/jenkins/vm-centos-test-rpm',
  $osci_centos_remote_dir               = 'vm-centos-test-rpm',
  $osci_obs_jenkins_key                 = '',
  $osci_obs_jenkins_key_contents        = '',
  $osci_rsync_source_server             = '',
  $osci_test                            = false,
  $osci_trusty_image_name               = 'trusty.qcow2',
  $osci_trusty_job_dir                  = '/home/jenkins/vm-trusty-test-deb',
  $osci_trusty_remote_dir               = 'vm-trusty-test-deb',
  $osci_ubuntu_image_name               = 'ubuntu-deb-test.qcow2',
  $osci_ubuntu_job_dir                  = '/home/jenkins/vm-ubuntu-test-deb',
  $osci_ubuntu_remote_dir               = 'vm-ubuntu-test-deb',
  $osci_vm_centos_jenkins_key           = '',
  $osci_vm_centos_jenkins_key_contents  = '',
  $osci_vm_trusty_jenkins_key           = '',
  $osci_vm_trusty_jenkins_key_contents  = '',
  $osci_vm_ubuntu_jenkins_key           = '',
  $osci_vm_ubuntu_jenkins_key_contents  = '',
  $ostf_db                              = ['ostf'],
  $pam_filter                           = '',
  $pam_password                         = '',
  $run_tests                            = false,
  $seed_cleanup_dirs                    = [
    {
      'dir'     => '/var/www/fuelweb-iso', # directory to poll
      'ttl'     => 10, # time to live in days
      'pattern' => 'fuel-*', # pattern to filter files in directory
    },
    {
      'dir'     => '/srv/downloads',
      'ttl'     => 1,
      'pattern' => 'fuel-*',
    }
  ],
  $simple_syntax_check                  = false,
  $sudo_commands                        = ['/sbin/ebtables'],
  $tls_cacertdir                        = '',
  $verify_fuel_astute                   = false,
  $verify_fuel_docs                     = false,
  $verify_fuel_pkgs_requirements        = false,
  $verify_fuel_stats                    = false,
  $verify_fuel_web                      = false,
  $verify_fuel_web_npm_packages         = ['casperjs','grunt-cli','gulp','phantomjs'],
  $verify_jenkins_jobs                  = false,
  $workspace                            = '/home/jenkins/workspace',
  $x11_display_num                      = 99,
) {

  if (!defined(Class['::fuel_project::common'])) {
    class { '::fuel_project::common' :
      external_host     => $external_host,
      ldap              => $ldap,
      ldap_uri          => $ldap_uri,
      ldap_base         => $ldap_base,
      tls_cacertdir     => $tls_cacertdir,
      pam_password      => $pam_password,
      pam_filter        => $pam_filter,
      bind_policy       => $bind_policy,
      ldap_ignore_users => $ldap_ignore_users,
    }
  }

  class { 'transmission::daemon' :}

  if ($jenkins_swarm_slave == true) {
    class { '::jenkins::swarm_slave' :}
  } else {
    class { '::jenkins::slave' :}
  }

  # jenkins should be in www-data group by default
  User <| title == 'jenkins' |> {
    groups  +> 'www-data',
  }

  class {'::devopslib::downloads_cleaner' :
    cleanup_dirs => $seed_cleanup_dirs,
    clean_seeds  => true,
  }

  ensure_packages(['git', 'python-seed-client'])

  # release status reports
  if ($build_fuel_iso == true or $run_tests == true) {
    class { '::landing_page::updater' :}
  }

  # FIXME: Legacy compability LP #1418927
  cron { 'devops-env-cleanup' :
    ensure => 'absent',
  }
  file { '/usr/local/bin/devops-env-cleanup.sh' :
    ensure => 'absent',
  }
  file { '/etc/devops/local_settings.py' :
    ensure => 'absent',
  }
  file { '/etc/devops' :
    ensure  => 'absent',
    force   => true,
    require => File['/etc/devops/local_settings.py'],
  }
  package { 'python-devops' :
    ensure            => 'absent',
    uninstall_options => ['purge']
  }
  # /FIXME

  file { '/home/jenkins/.ssh' :
    ensure  => 'directory',
    mode    => '0700',
    owner   => 'jenkins',
    group   => 'jenkins',
    require => User['jenkins'],
  }


  if ($local_ssh_private_key) {
    file { '/home/jenkins/.ssh/id_rsa' :
      ensure  => 'present',
      mode    => '0600',
      owner   => 'jenkins',
      group   => 'jenkins',
      content => $local_ssh_private_key,
      require => [
        User['jenkins'],
        File['/home/jenkins/.ssh'],
      ]
    }
  }

  if ($local_ssh_public_key) {
    file { '/home/jenkins/.ssh/id_rsa.pub' :
      ensure  => 'present',
      mode    => '0600',
      owner   => 'jenkins',
      group   => 'jenkins',
      content => $local_ssh_public_key,
      require => [
        User['jenkins'],
        File['/home/jenkins/.ssh'],
      ]
    }
  }

  # 'known_hosts' manage
  if ($known_hosts) {
    create_resources('ssh::known_host', $known_hosts, {
      user      => 'jenkins',
      overwrite => $known_hosts_overwrite,
      require   => User['jenkins'],
    })
  }

  # Run system tests
  if ($run_tests == true) {
    if ($libvirt_default_network == false) {
      class { '::libvirt' :
        listen_tls         => false,
        listen_tcp         => true,
        auth_tcp           => 'none',
        listen_addr        => '127.0.0.1',
        mdns_adv           => false,
        unix_sock_group    => 'libvirtd',
        unix_sock_rw_perms => '0777',
        python             => true,
        qemu               => true,
        tcp_port           => 16509,
        deb_default        => {
          'libvirtd_opts' => '-d -l',
        }
      }
    }

    libvirt_pool { 'default' :
      ensure    => 'present',
      type      => 'dir',
      autostart => true,
      target    => '/var/lib/libvirt/images',
      require   => Class['libvirt'],
    }

    # python-devops installation
    if (!defined(Class['::postgresql::server'])) {
      class { '::postgresql::server' : }
    }

    ::postgresql::server::db { 'devops' :
      user     => 'devops',
      password => 'devops',
    }

    ::postgresql::server::db { 'fuel_devops' :
      user     => 'fuel_devops',
      password => 'fuel_devops',
    }
    # /python-devops installation

    $system_tests_packages = [
      # dependencies
      'libevent-dev',
      'libffi-dev',
      'libvirt-dev',
      'python-dev',
      'python-psycopg2',
      'python-virtualenv',
      'python-yaml',
      'pkg-config',
      'postgresql-server-dev-all',

      # diagnostic utilities
      'htop',
      'sysstat',
      'dstat',
      'vncviewer',
      'tcpdump',

      # usefull utils
      'screen',

      # repo building utilities
      'reprepro',
      'createrepo',
    ]

    ensure_packages($system_tests_packages)

    file { $workspace :
      ensure  => 'directory',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => User['jenkins'],
    }

    ensure_resource('file', "${workspace}/iso", {
      ensure  => 'directory',
      owner   => 'jenkins',
      group   => 'jenkins',
      mode    => '0755',
      require => [
        User['jenkins'],
        File[$workspace],
      ],
    })

    file { '/etc/sudoers.d/systest' :
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => template('fuel_project/jenkins/slave/system_tests.sudoers.d.erb'),
    }

    # Working with bridging
    # we need to load module to be sure /proc/sys/net/bridge branch will be created
    exec { 'load_bridge_module' :
      command   => '/sbin/modprobe bridge',
      user      => 'root',
      logoutput => 'on_failure',
    }

    # ensure bridge module will be loaded on system start
    augeas { 'sysctl-net.bridge.bridge-nf-call-iptables' :
      context => '/files/etc/modules',
      changes => 'clear bridge',
    }

    sysctl { 'net.bridge.bridge-nf-call-iptables' :
      value   => '0',
      require => Exec['load_bridge_module'],
    }

    sysctl { 'vm.swappiness' :
      value => '0',
    }
  }

  # provide env for building packages, actaully for "make sources"
  # from fuel-main and remove duplicate packages from build ISO
  if ($build_fuel_packages or $build_fuel_iso) {
    $build_fuel_packages_list = [
      'devscripts',
      'libparse-debcontrol-perl',
      'make',
      'mock',
      'nodejs',
      'nodejs-legacy',
      'npm',
      'pigz',
      'lzop',
      'python-setuptools',
      'python-rpm',
      'python-pbr',
      'reprepro',
      'ruby',
      'sbuild',
    ]

    User <| title == 'jenkins' |> {
      groups  +> 'mock',
      require => Package[$build_fuel_packages_list],
    }

    ensure_packages($build_fuel_packages_list)

    if ($build_fuel_npm_packages) {
      ensure_packages($build_fuel_npm_packages, {
        provider => npm,
        require  => Package['npm'],
      })
    }
  }

  # Build ISO
  if ($build_fuel_iso == true) {
    $build_fuel_iso_packages = [
      'bc',
      'build-essential',
      'createrepo',
      'debmirror',
      'debootstrap',
      'dosfstools',
      'extlinux',
      'genisoimage',
      'isomd5sum',
      'kpartx',
      'libconfig-auto-perl',
      'libmysqlclient-dev',
      'libparse-debian-packages-perl',
      'libyaml-dev',
      'lrzip',
      'python-daemon',
      'python-ipaddr',
      'python-jinja2',
      'python-nose',
      'python-paramiko',
      'python-pip',
      'python-xmlbuilder',
      'python-virtualenv',
      'python-yaml',
      'realpath',
      'ruby-bundler',
      'ruby-builder',
      'ruby-dev',
      'rubygems-integration',
      'syslinux',
      'time',
      'unzip',
      'xorriso',
      'yum',
      'yum-utils',
    ]

    ensure_packages($build_fuel_iso_packages)

    ensure_resource('file', '/var/www', {
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    })

    ensure_resource('file', '/var/www/fwm', {
      ensure  => 'directory',
      owner   => 'jenkins',
      group   => 'jenkins',
      mode    => '0755',
      require => [
        User['jenkins'],
        File['/var/www'],
      ],
    })

    if ($http_share_iso) {
      class { '::fuel_project::nginx' :}
      ::nginx::resource::vhost { 'share':
        server_name => ['_'],
        autoindex   => 'on',
        www_root    => '/var/www',
      }

      ensure_resource('file', '/var/www/fuelweb-iso', {
        ensure  => 'directory',
        owner   => 'jenkins',
        group   => 'jenkins',
        mode    => '0755',
        require => [
          User['jenkins'],
          File['/var/www'],
        ],
      })
    }

    if (!defined(Package['multistrap'])) {
      package { 'multistrap' :
        ensure => '2.1.6ubuntu3'
      }
    }
    apt::pin { 'multistrap' :
      packages => 'multistrap',
      version  => '2.1.6ubuntu3',
      priority => 1000,
    }

    # LP: https://bugs.launchpad.net/ubuntu/+source/libxml2/+bug/1375637
    if (!defined(Package['libxml2'])) {
      package { 'libxml2' :
        ensure => '2.9.1+dfsg1-ubuntu1',
      }
    }
    if (!defined(Package['python-libxml2'])) {
      package { 'python-libxml2' :
        ensure => '2.9.1+dfsg1-ubuntu1',
      }
    }
    apt::pin { 'libxml2' :
      packages => 'libxml2 python-libxml2',
      version  => '2.9.1+dfsg1-ubuntu1',
      priority => 1000,
    }
    # /LP

    file { 'jenkins-sudo-for-build_iso' :
      path    => '/etc/sudoers.d/build_fuel_iso',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => template('fuel_project/jenkins/slave/build_iso.sudoers.d.erb')
    }

  }

  # osci_tests - for deploying osci jenkins slaves
  if ($osci_test == true) {

    # osci needed packages
    $osci_test_packages = [
      'osc',
      'yum-utils',
    ]

    ensure_packages($osci_test_packages)

    # sudo for user 'jenkins'
    file { 'jenkins-sudo-for-osci-vm' :
      path    => '/etc/sudoers.d/jenkins_sudo',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => template('fuel_project/jenkins/slave/build_iso.sudoers.d.erb'),
      require => User['jenkins'],
    }

    # obs client settings
    file { 'oscrc' :
      path    => '/home/jenkins/.oscrc',
      owner   => 'jenkins',
      group   => 'jenkins',
      mode    => '0644',
      content => template('fuel_project/jenkins/slave/oscrc.erb'),
      require => [
        Package[$osci_test_packages],
        User['jenkins'],
      ],
    }

    # osci kvm settings
    if (!defined(Class['::libvirt'])) {
      class { '::libvirt' :
        mdns_adv           => false,
        unix_sock_rw_perms => '0777',
        qemu               => true,
        defaultnetwork     => true,
      }
    }

    # osci needed directories
    file {
          [
            $osci_ubuntu_job_dir,
            $osci_centos_job_dir,
            $osci_trusty_job_dir
          ] :
      ensure  => 'directory',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => User['jenkins'],
    }

    # rsync of vm images from existing rsync share
    class { 'rsync': package_ensure => 'present' }

    rsync::get { $osci_ubuntu_image_name :
      source  => "rsync://${osci_rsync_source_server}/${osci_ubuntu_remote_dir}/${osci_ubuntu_image_name}",
      path    => $osci_ubuntu_job_dir,
      timeout => 14400,
      require => [
        File[$osci_ubuntu_job_dir],
        User['jenkins'],
      ],
    }

    rsync::get { $osci_centos_image_name :
      source  => "rsync://${osci_rsync_source_server}/${osci_centos_remote_dir}/${osci_centos_image_name}",
      path    => $osci_centos_job_dir,
      timeout => 14400,
      require => [
        File[$osci_centos_job_dir],
        User['jenkins'],
      ],
    }

    rsync::get { $osci_trusty_image_name :
      source  => "rsync://${osci_rsync_source_server}/${osci_trusty_remote_dir}/${osci_trusty_image_name}",
      path    => $osci_trusty_job_dir,
      timeout => 14400,
      require => [
        File[$osci_trusty_job_dir],
        User['jenkins'],
      ],
    }

    # osci needed ssh keys
    file {
        [
          $osci_obs_jenkins_key,
          $osci_vm_ubuntu_jenkins_key,
          $osci_vm_centos_jenkins_key,
          $osci_vm_trusty_jenkins_key
        ]:
      owner   => 'jenkins',
      group   => 'nogroup',
      mode    => '0600',
      content => [
        $osci_obs_jenkins_key_contents,
        $osci_vm_ubuntu_jenkins_key_contents,
        $osci_vm_centos_jenkins_key_contents,
        $osci_vm_trusty_jenkins_key_contents
      ],
      require => [
        File[
          '/home/jenkins/.ssh',
          $osci_ubuntu_job_dir,
          $osci_centos_job_dir,
          $osci_trusty_job_dir
        ],
        User['jenkins'],
      ],
    }
  }

  # *** Custom tests ***

  # anonymous statistics tests
  if ($verify_fuel_stats) {
    class { '::fuel_stats::tests' : }
  }

  # Web tests by verify-fuel-web, stackforge-verify-fuel-web, verify-fuel-ostf
  if ($verify_fuel_web) {
    $verify_fuel_web_packages = [
      'inkscape',
      'libxslt1-dev',
      'nodejs-legacy',
      'npm',
      'postgresql-server-dev-all',
      'python-all-dev',
      'python-cloud-sptheme',
      'python-sphinx',
      'python-tox',
      'python-virtualenv',
      'python2.6',
      'python2.6-dev',
      'python3-dev',
      'rst2pdf',
    ]

    ensure_packages($verify_fuel_web_packages)

    if ($verify_fuel_web_npm_packages) {
      ensure_packages($verify_fuel_web_npm_packages, {
        provider => npm,
        require  => Package['npm'],
      })
    }

    if ($fuel_web_selenium) {
      $selenium_packages = [
        'chromium-browser',
        'chromium-chromedriver',
        'firefox',
        'imagemagick',
        'x11-apps',
        'xfonts-100dpi',
        'xfonts-75dpi',
        'xfonts-cyrillic',
        'xfonts-scalable',
      ]
      ensure_packages($selenium_packages)

      class { 'display' :
        display => $x11_display_num,
        width   => 1366,
        height  => 768,
      }

    }

    if (!defined(Class['postgresql::server'])) {
      class { 'postgresql::server' : }
    }

    postgresql::server::db { $nailgun_db:
      user     => 'nailgun',
      password => 'nailgun',
    }
    postgresql::server::db { $ostf_db:
      user     => 'ostf',
      password => 'ostf',
    }
    file { '/var/log/nailgun' :
      ensure  => directory,
      owner   => 'jenkins',
      require => User['jenkins'],
    }
  }

  # For the below roles we need to have rvm base class
  if ($verify_fuel_astute or $simple_syntax_check or $build_fuel_plugins) {
    class { 'rvm' : }
    rvm::system_user { 'jenkins': }
    rvm_system_ruby { "ruby-${ruby_version}" :
      ensure      => 'present',
      default_use => true,
      require     => Class['rvm'],
    }
  }


  # Astute tests require only rvm package
  if ($verify_fuel_astute) {
    rvm_gem { 'bundler' :
      ensure       => 'present',
      ruby_version => "ruby-${ruby_version}",
      require      => Rvm_system_ruby["ruby-${ruby_version}"],
    }
    # FIXME: remove this hack, create package raemon?
    $raemon_file = '/tmp/raemon-0.3.0.gem'
    file { $raemon_file :
      source => 'puppet:///modules/fuel_project/gems/raemon-0.3.0.gem',
    }
    rvm_gem { 'raemon' :
      ensure       => 'present',
      ruby_version => "ruby-${ruby_version}",
      source       => $raemon_file,
      require      => [ Rvm_system_ruby["ruby-${ruby_version}"], File[$raemon_file] ],
    }
  }

  # Simple syntax check by:
  # - verify-fuel-devops
  # - fuellib_review_syntax_check (puppet tests)
  if ($simple_syntax_check) {
    $syntax_check_packages = [
      'libxslt1-dev',
      'puppet-lint',
      'python-flake8',
      'python-tox',
    ]

    ensure_packages($syntax_check_packages)

    rvm_gem { 'puppet-lint' :
      ensure       => 'installed',
      ruby_version => "ruby-${ruby_version}",
      require      => Rvm_system_ruby["ruby-${ruby_version}"],
    }
  }

  # Check tasks graph
  if ($check_tasks_graph){
    $tasks_graph_check_packages = [
      'python-pytest',
      'python-jsonschema',
      'python-networkx',
    ]

    ensure_packages($tasks_graph_check_packages)
  }

  # Verify Fuel docs
  if ($verify_fuel_docs) {
    $verify_fuel_docs_packages =  [
      'inkscape',
      'libjpeg-dev',
      'make',
      'plantuml',
      'python-cloud-sptheme',
      'python-sphinx',
      'python-sphinxcontrib.plantuml',
      'rst2pdf',
      'texlive-font-utils', # provides epstopdf binary
    ]

    ensure_packages($verify_fuel_docs_packages)
  }

  # Verify Jenkins jobs
  if ($verify_jenkins_jobs) {
    $verify_jenkins_jobs_packages = [
      'bats',
      'python-tox',
      'shellcheck',
    ]

    ensure_packages($verify_jenkins_jobs_packages)
  }

  # Verify and Build fuel-plugins project
  if ($build_fuel_plugins) {
    $build_fuel_plugins_packages = [
      'rpm',
      'createrepo',
      'dpkg-dev',
      'libyaml-dev',
      'make',
      'python-dev',
      'ruby-dev',
      'gcc',
      'python2.6',
      'python2.6-dev',
      'python-tox',
      'python-virtualenv',
    ]

    ensure_packages($build_fuel_plugins_packages)

    # we also need fpm gem
    rvm_gem { 'fpm' :
      ensure       => 'present',
      ruby_version => "ruby-${ruby_version}",
      require      => [
        Rvm_system_ruby["ruby-${ruby_version}"],
        Package['make'],
      ],
    }
  }

  # verify requirements-{deb|rpm}.txt files from fuel-main project
  # test-requirements-{deb|rpm} jobs on fuel-ci
  if ($verify_fuel_pkgs_requirements==true){
    $verify_fuel_requirements_packages = [
      'devscripts',
      'yum-utils',
    ]

    ensure_packages($verify_fuel_requirements_packages)
  }

  if ($install_docker or $build_fuel_iso or $build_fuel_packages) {
    if (!$docker_package) {
      fail('You must define docker package explicitly')
    }

    if (!defined(Package[$docker_package])) {
      package { $docker_package :
        ensure  => 'present',
        require => Package['lxc-docker'],
      }
    }

    #actually docker have api, and in some cases it will not be automatically started and enabled
    if ($docker_service and (!defined(Service[$docker_service]))) {
      service { $docker_service :
        ensure    => 'running',
        enable    => true,
        hasstatus => true,
        require   => [
          Package[$docker_package],
          Group['docker'],
        ],
      }
    }

    package { 'lxc-docker' :
      ensure => 'absent',
    }

    group { 'docker' :
      ensure  => 'present',
      require => Package[$docker_package],
    }

    User <| title == 'jenkins' |> {
      groups  +> 'docker',
      require => Group['docker'],
    }

    if ($external_host) {
      firewall { '010 accept all to docker0 interface':
        proto   => 'all',
        iniface => 'docker0',
        action  => 'accept',
        require => Package[$docker_package],
      }
    }
  }

  if($ldap_sudo_group) {
    file { '/etc/sudoers.d/sandbox':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => template('fuel_project/jenkins/slave/sandbox.sudoers.d.erb'),
    }
  }
}
