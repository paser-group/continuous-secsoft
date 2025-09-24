# == Class: vitrage::deps
#
#  Vitrage anchors and dependency management
#
class vitrage::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'vitrage::install::begin': }
  -> Package<| tag == 'vitrage-package'|>
  ~> anchor { 'vitrage::install::end': }
  -> anchor { 'vitrage::config::begin': }
  -> Vitrage_config<||>
  ~> anchor { 'vitrage::config::end': }
  -> anchor { 'vitrage::db::begin': }
  -> anchor { 'vitrage::db::end': }
  ~> anchor { 'vitrage::dbsync::begin': }
  -> anchor { 'vitrage::dbsync::end': }
  ~> anchor { 'vitrage::service::begin': }
  ~> Service<| tag == 'vitrage-service' |>
  ~> anchor { 'vitrage::service::end': }

  # policy config should occur in the config block also.
  Anchor['vitrage::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['vitrage::config::end']

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['vitrage::dbsync::begin']

  # Installation or config changes will always restart services.
  Anchor['vitrage::install::end'] ~> Anchor['vitrage::service::begin']
  Anchor['vitrage::config::end']  ~> Anchor['vitrage::service::begin']
}
