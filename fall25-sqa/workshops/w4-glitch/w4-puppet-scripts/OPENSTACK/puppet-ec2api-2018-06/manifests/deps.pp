# == Class: ec2api::deps
#
#  Ec2api anchors and dependency management
#
class ec2api::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'ec2api::install::begin': }
  -> Package<| tag == 'ec2api-package'|>
  ~> anchor { 'ec2api::install::end': }
  -> anchor { 'ec2api::config::begin': }
  -> Ec2api_config<||>
  ~> anchor { 'ec2api::config::end': }
  -> anchor { 'ec2api::db::begin': }
  -> anchor { 'ec2api::db::end': }
  ~> anchor { 'ec2api::dbsync::begin': }
  -> anchor { 'ec2api::dbsync::end': }
  ~> anchor { 'ec2api::service::begin': }
  ~> Service<| tag == 'ec2api-service' |>
  ~> anchor { 'ec2api::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['ec2api::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['ec2api::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['ec2api::config::end']

  # Installation or config changes will always restart services.
  Anchor['ec2api::install::end'] ~> Anchor['ec2api::service::begin']
  Anchor['ec2api::config::end']  ~> Anchor['ec2api::service::begin']
}
