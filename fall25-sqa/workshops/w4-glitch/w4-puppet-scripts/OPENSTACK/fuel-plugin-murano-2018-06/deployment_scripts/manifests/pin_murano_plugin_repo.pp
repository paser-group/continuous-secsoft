notice('MURANO PLUGIN: pin_murano_plugin_repo.pp')

$detach_murano  = hiera_hash('detach-murano')
$plugin_version = $detach_murano['metadata']['plugin_version']

# Murano plugin repo doesn't have originator, release
$pins =  { "detach-murano-${plugin_version}" =>
              {
                 'priority' => 1200,
                 'label'    => 'detach-murano',
              },
          }

if ! empty($pins) {
  create_resources(apt::pin, $pins)
}
