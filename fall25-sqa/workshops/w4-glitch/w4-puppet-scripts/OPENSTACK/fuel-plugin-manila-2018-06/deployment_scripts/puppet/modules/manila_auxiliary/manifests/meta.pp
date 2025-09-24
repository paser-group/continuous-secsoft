class manila_auxiliary::meta (
  ) {
  file {'/tmp/meta.sh':
    source => 'puppet:///modules/manila_auxiliary/meta.sh',
    mode   => 0755,
    }->
    exec {'manila_meta':
      command => '/tmp/meta.sh',
      path    => '/bin:/usr/bin',
    }
  }
