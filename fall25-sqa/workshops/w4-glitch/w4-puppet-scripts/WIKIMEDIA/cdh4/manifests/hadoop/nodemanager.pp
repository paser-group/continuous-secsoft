# == Class cdh::hadoop::nodemanager
# Installs and configures a Hadoop NodeManager worker node.
#
class cdh::hadoop::nodemanager {
    Class['cdh::hadoop'] -> Class['cdh::hadoop::nodemanager']


    package { ['hadoop-yarn-nodemanager', 'hadoop-mapreduce']:
        ensure => 'installed',
    }

    # NodeManager (YARN TaskTracker)
    service { 'hadoop-yarn-nodemanager':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        alias      => 'nodemanager',
        require    => [Package['hadoop-yarn-nodemanager', 'hadoop-mapreduce']],
    }
}

