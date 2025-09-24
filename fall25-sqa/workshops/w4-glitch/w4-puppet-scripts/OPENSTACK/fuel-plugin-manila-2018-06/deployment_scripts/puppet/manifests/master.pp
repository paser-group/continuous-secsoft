notify {'MODULAR: fuel-plugin-manila/master': }

file {'/tmp/manila_master':
  ensure  => file,
  content => 'I am the file',
}
