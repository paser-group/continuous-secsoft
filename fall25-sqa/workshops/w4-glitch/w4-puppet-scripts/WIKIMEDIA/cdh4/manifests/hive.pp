# == Class cdh::hive
#
# Installs Hive packages (needed for Hive Client).
# Use this in conjunction with cdh::hive::master to install and set up a
# Hive Server and Hive Metastore.
# This also installs hive-hcatalog
#
# == Parameters
# $metastore_host                - fqdn of the metastore host
# $zookeeper_hosts               - Array of zookeeper hostname/IP(:port)s.
#                                  Default: undef (zookeeper lock management
#                                  will not be used).
#
# $jdbc_database                 - Metastore JDBC database name.
#                                  Default: 'hive_metastore'
# $jdbc_username                 - Metastore JDBC username.  Default: hive
# $jdbc_password                 - Metastore JDBC password.  Default: hive
# $jdbc_host                     - Metastore JDBC hostname.  Default: localhost
# $jdbc_port                     - Metastore JDBC port.      Default: 3306
# $jdbc_driver                   - Metastore JDBC driver class name.
#                                  Default: org.apache.derby.jdbc.EmbeddedDriver
# $jdbc_protocol                 - Metastore JDBC protocol.  Default: mysql
#
# $db_root_username              - username for metastore database creation commands. Default: undef
# $db_root_password              - password for metastore database creation commands.
#                                  Only set these if your root user cannot issue database
#                                  commands without a different username and password.
#                                  Default: undef
# $auxpath                       - Additional path to pass to hive.  Default: undef
# $exec_parallel_thread_number   - Number of jobs at most can be executed in parallel.
#                                  Set this to 0 to disable parallel execution.
# $optimize_skewjoin             - Enable or disable skew join optimization.
#                                  Default: false
# $skewjoin_key                  - Number of rows where skew join is used.
#                                - Default: 10000
# $skewjoin_mapjoin_map_tasks    - Number of map tasks used in the follow up
#                                  map join jobfor a skew join.   Default: 10000.
# $skewjoin_mapjoin_min_split    - Skew join minimum split size.  Default: 33554432
#
# $stats_enabled                 - Enable or disable temp Hive stats.  Default: false
# $stats_dbclass                 - The default database class that stores
#                                  temporary hive statistics.  Default: jdbc:derby
# $stats_jdbcdriver              - JDBC driver for the database that stores
#                                  temporary hive statistics.
#                                  Default: org.apache.derby.jdbc.EmbeddedDriver
# $stats_dbconnectionstring      - Connection string for the database that stores
#                                  temporary hive statistics.
#                                  Default: jdbc:derby:;databaseName=TempStatsStore;create=true
#
class cdh::hive(
    $metastore_host,
    $zookeeper_hosts             = $cdh::hive::defaults::zookeeper_hosts,

    $jdbc_database               = $cdh::hive::defaults::jdbc_database,
    $jdbc_username               = $cdh::hive::defaults::jdbc_username,
    $jdbc_password               = $cdh::hive::defaults::jdbc_password,
    $jdbc_host                   = $cdh::hive::defaults::jdbc_host,
    $jdbc_port                   = $cdh::hive::defaults::jdbc_port,
    $jdbc_driver                 = $cdh::hive::defaults::jdbc_driver,
    $jdbc_protocol               = $cdh::hive::defaults::jdbc_protocol,

    $db_root_username            = $cdh::hive::defaults::db_root_username,
    $db_root_password            = $cdh::hive::defaults::db_root_password,

    $auxpath                     = $cdh::hive::defaults::auxpath,

    $exec_parallel_thread_number = $cdh::hive::defaults::exec_parallel_thread_number,
    $optimize_skewjoin           = $cdh::hive::defaults::optimize_skewjoin,
    $skewjoin_key                = $cdh::hive::defaults::skewjoin_key,
    $skewjoin_mapjoin_map_tasks  = $cdh::hive::defaults::skewjoin_mapjoin_map_tasks,

    $stats_enabled               = $cdh::hive::defaults::stats_enabled,
    $stats_dbclass               = $cdh::hive::defaults::stats_dbclass,
    $stats_jdbcdriver            = $cdh::hive::defaults::stats_jdbcdriver,
    $stats_dbconnectionstring    = $cdh::hive::defaults::stats_dbconnectionstring,

    $hive_site_template          = $cdh::hive::defaults::hive_site_template,
    $hive_log4j_template         = $cdh::hive::defaults::hive_log4j_template,
    $hive_exec_log4j_template    = $cdh::hive::defaults::hive_exec_log4j_template
) inherits cdh::hive::defaults
{
    Class['cdh::hadoop'] -> Class['cdh::hive']

    package { 'hive':
        ensure => 'installed',
    }
    $config_directory = "/etc/hive/conf.${cdh::hadoop::cluster_name}"
    # Create the $cluster_name based $config_directory.
    file { $config_directory:
        ensure  => 'directory',
        require => Package['hive'],
    }
    cdh::alternative { 'hive-conf':
        link    => '/etc/hive/conf',
        path    => $config_directory,
    }

    # If we need more hcatalog services
    # (e.g. webhcat), this may be moved
    # to a class of its own.
    package { 'hive-hcatalog':
        ensure  => 'installed',
        require => Package['hive'],
    }

    # Make sure hive-site.xml is not world readable on the
    # metastore host.  On the metastore host, hive-site.xml
    # will contain database connection credentials.
    $hive_site_mode = $metastore_host ? {
        $::fqdn => '0440',
        default => '0444',
    }
    file { "${config_directory}/hive-site.xml":
        content => template($hive_site_template),
        mode    => $hive_site_mode,
        owner   => 'hive',
        group   => 'hive',
        require => Package['hive'],
    }
    file { "${config_directory}/hive-log4j.properties":
        content => template($hive_log4j_template),
        require => Package['hive'],
    }
    file { "${config_directory}/hive-exec-log4j.properties":
        content => template($hive_exec_log4j_template),
        require => Package['hive'],
    }
}