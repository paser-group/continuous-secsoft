class { 'nova':
  ensure_package     => 'absent',
  rabbit_password    => 'not important as removed',
}
