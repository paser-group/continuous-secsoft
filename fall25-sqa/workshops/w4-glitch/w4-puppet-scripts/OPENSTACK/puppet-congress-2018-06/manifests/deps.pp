# == Class: congress::deps
#
#  Congress anchors and dependency management
#
class congress::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'congress::install::begin': }
  -> Package<| tag == 'congress-package'|>
  ~> anchor { 'congress::install::end': }
  -> anchor { 'congress::config::begin': }
  -> Congress_config<||>
  ~> anchor { 'congress::config::end': }
  -> anchor { 'congress::db::begin': }
  -> anchor { 'congress::db::end': }
  ~> anchor { 'congress::dbsync::begin': }
  -> anchor { 'congress::dbsync::end': }
  ~> anchor { 'congress::service::begin': }
  ~> Service<| tag == 'congress-service' |>
  ~> anchor { 'congress::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['congress::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['congress::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['congress::config::end']

  # Installation or config changes will always restart services.
  Anchor['congress::install::end'] ~> Anchor['congress::service::begin']
  Anchor['congress::config::end']  ~> Anchor['congress::service::begin']
}
