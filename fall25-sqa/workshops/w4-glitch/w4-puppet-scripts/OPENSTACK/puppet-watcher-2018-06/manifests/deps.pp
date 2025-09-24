# == Class: watcher::deps
#
#  watcher anchors and dependency management
#
class watcher::deps {
  anchor { 'watcher::install::begin': }
  -> Package<| tag == 'watcher-package'|>
  ~> anchor { 'watcher::install::end': }
  -> anchor { 'watcher::config::begin': }
  -> Watcher_config<||>
  ~> anchor { 'watcher::config::end': }
  ~> anchor { 'watcher::db::begin': }
  ~> anchor { 'watcher::db::end': }
  ~> anchor { 'watcher::db::create_schema::begin': }
  ~> anchor { 'watcher::db::create_schema::end': }
  ~> anchor { 'watcher::db::upgrade::begin': }
  ~> anchor { 'watcher::db::upgrade::end': }
  ~> anchor { 'watcher::service::begin': }
  ~> Service<| tag == 'watcher-service' |>
  ~> anchor { 'watcher::service::end': }

  # policy config should occur in the config block also.
  Anchor['watcher::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['watcher::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['watcher::db::create_schema::begin']

  Anchor['watcher::install::end'] ~> Anchor['watcher::service::begin']
  Anchor['watcher::config::end']  ~> Anchor['watcher::service::begin']

  anchor { 'watcher-start':
    require => Anchor['watcher::install::end'],
    before  => Anchor['watcher::config::begin'],
  }
}
