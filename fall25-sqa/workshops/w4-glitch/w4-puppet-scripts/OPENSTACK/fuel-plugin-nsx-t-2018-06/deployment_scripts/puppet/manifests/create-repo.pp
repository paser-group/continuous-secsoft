notice('fuel-plugin-nsx-t: create-repo.pp')

include ::nsxt::params

$settings = hiera($::nsxt::params::hiera_key)
$managers = $settings['nsx_api_managers']
$username = $settings['nsx_api_user']
$password = $settings['nsx_api_password']

class { '::nsxt::create_repo':
  managers => $managers,
  username => $username,
  password => $password,
}
