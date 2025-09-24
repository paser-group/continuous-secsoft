# == Class: rally::deps
#
#  Rally anchors and dependency management
#
class rally::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'rally::install::begin': }
  -> Package<| tag == 'rally-package'|>
  ~> anchor { 'rally::install::end': }
  -> anchor { 'rally::config::begin': }
  -> Rally_config<||>
  ~> anchor { 'rally::config::end': }
  -> anchor { 'rally::db::begin': }
  -> anchor { 'rally::db::end': }
  ~> anchor { 'rally::dbsync::begin': }
  -> anchor { 'rally::dbsync::end': }
  ~> anchor { 'rally::service::begin': }
  ~> Service<| tag == 'rally-service' |>
  ~> anchor { 'rally::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['rally::dbsync::begin']

  # Installation or config changes will always restart services.
  Anchor['rally::install::end'] ~> Anchor['rally::service::begin']
  Anchor['rally::config::end']  ~> Anchor['rally::service::begin']
}
