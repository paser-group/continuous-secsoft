notify {'MODULAR: fuel-plugin-manila/init_share': }

$inits = {
  'manila-share' => {
    desc => 'manila-share init',
    srv  => 'manila-share',},
}

create_resources('::manila_auxiliary::initd', $inits)
