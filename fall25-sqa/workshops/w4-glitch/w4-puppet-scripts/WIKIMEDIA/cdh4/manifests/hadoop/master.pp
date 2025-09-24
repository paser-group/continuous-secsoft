# == Class cdh::hadoop::master
# Wrapper class for Hadoop master node services:
# - NameNode
# - ResourceManager and HistoryServer (YARN)
# OR
# - JobTracker (MRv1).
#
class cdh::hadoop::master {
    Class['cdh::hadoop'] -> Class['cdh::hadoop::master']

    include cdh::hadoop::namenode::primary

    include cdh::hadoop::resourcemanager
    include cdh::hadoop::historyserver
}
