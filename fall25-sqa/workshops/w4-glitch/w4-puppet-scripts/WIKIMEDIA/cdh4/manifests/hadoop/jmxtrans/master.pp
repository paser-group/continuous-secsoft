# == Class cdh::hadoop::jmxtrans::master
# Convenience class to include jmxtrans classes for NameNode and ResourceManager
class cdh::hadoop::jmxtrans::master(
    $ganglia        = undef,
    $graphite       = undef,
    $outfile        = undef,
)
{
    class { ['cdh::hadoop::jmxtrans::namenode', 'cdh::hadoop::jmxtrans::resourcemanager']:
        ganglia  => $ganglia,
        graphite => $graphite,
        outfile  => $outfile,
    }
}