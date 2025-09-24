notify {'MODULAR: fuel-plugin-manila/init_controller': }

$inits = {
  'manila-api' => {
    desc => 'manila-api init',
    srv  => 'manila-api',},
  'manila-scheduler' => {
    desc => 'manila-scheduler init',
    srv  => 'manila-scheduler',},
}

create_resources('::manila_auxiliary::initd', $inits)
