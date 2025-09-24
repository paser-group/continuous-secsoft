# == Class: zaqar::deps
#
#  Zaqar anchors and dependency management
#
class zaqar::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'zaqar::install::begin': }
  -> Package<| tag == 'zaqar-package'|>
  ~> anchor { 'zaqar::install::end': }
  -> anchor { 'zaqar::config::begin': }
  -> Zaqar_config<||>
  ~> anchor { 'zaqar::config::end': }
  -> anchor { 'zaqar::db::begin': }
  -> anchor { 'zaqar::db::end': }
  ~> anchor { 'zaqar::dbsync::begin': }
  -> anchor { 'zaqar::dbsync::end': }
  ~> anchor { 'zaqar::service::begin': }
  ~> Service<| tag == 'zaqar-service' |>
  ~> anchor { 'zaqar::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['zaqar::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['zaqar::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['zaqar::config::end']

  # Installation or config changes will always restart services.
  Anchor['zaqar::install::end'] ~> Anchor['zaqar::service::begin']
  Anchor['zaqar::config::end']  ~> Anchor['zaqar::service::begin']
}
