# == Class: tacker::deps
#
#  Tacker anchors and dependency management
#
class tacker::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'tacker::install::begin': }
  -> Package<| tag == 'tacker-package'|>
  ~> anchor { 'tacker::install::end': }
  -> anchor { 'tacker::config::begin': }
  -> Tacker_config<||>
  ~> anchor { 'tacker::config::end': }
  -> anchor { 'tacker::db::begin': }
  -> anchor { 'tacker::db::end': }
  ~> anchor { 'tacker::dbsync::begin': }
  -> anchor { 'tacker::dbsync::end': }
  ~> anchor { 'tacker::service::begin': }
  ~> Service<| tag == 'tacker-service' |>
  ~> anchor { 'tacker::service::end': }

  # policy config should occur in the config block also.
  Anchor['tacker::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['tacker::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['tacker::dbsync::begin']

  # Installation or config changes will always restart services.
  Anchor['tacker::install::end'] ~> Anchor['tacker::service::begin']
  Anchor['tacker::config::end']  ~> Anchor['tacker::service::begin']
}
