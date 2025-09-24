# == Class venv::init
#
class venv (
  $pip_opts     = '',
  $requirements = 'https://raw.github.com/stackforge/fuel-main/master/fuelweb_test/requirements.txt',
) {
  venv::venv { 'venv-nailgun-tests' :
    path         => '/home/jenkins/venv-nailgun-tests',
    requirements => $requirements,
    options      => '--system-site-packages',
    pip_opts     => $pip_opts,
    user         => 'jenkins',
  }
}
