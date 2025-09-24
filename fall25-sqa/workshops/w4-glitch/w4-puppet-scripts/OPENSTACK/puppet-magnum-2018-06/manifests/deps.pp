# == Class: magnum::deps
#
#  Magnum anchors and dependency management
#
class magnum::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'magnum::install::begin': }
  -> Package<| tag == 'magnum-package'|>
  ~> anchor { 'magnum::install::end': }
  -> anchor { 'magnum::config::begin': }
  -> Magnum_config<||>
  ~> anchor { 'magnum::config::end': }
  -> anchor { 'magnum::db::begin': }
  -> anchor { 'magnum::db::end': }
  ~> anchor { 'magnum::dbsync::begin': }
  -> anchor { 'magnum::dbsync::end': }
  ~> anchor { 'magnum::service::begin': }
  ~> Service<| tag == 'magnum-service' |>
  ~> anchor { 'magnum::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['magnum::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['magnum::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['magnum::config::end']

  # Installation or config changes will always restart services.
  Anchor['magnum::install::end'] ~> Anchor['magnum::service::begin']
  Anchor['magnum::config::end']  ~> Anchor['magnum::service::begin']
}
