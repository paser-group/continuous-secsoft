notify {'MODULAR: fuel-plugin-manila/init_data': }

$inits = {
  'manila-data' =>{
    desc => 'manila-data init',
    srv  => 'manila-data',},
}

create_resources('::manila_auxiliary::initd', $inits)
