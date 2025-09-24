# == Class qdr::service
#
# This class is called from qdr for qdrouterd service management
class qdr::service inherits qdr {

  $enable_service   = $::qdr::enable_service
  $ensure_service   = $::qdr::ensure_service
  $service_name     = $::qdr::params::service_name

  service { $service_name:
    ensure     => $ensure_service,
    enable     => $enable_service,
    hasstatus  => true,
    hasrestart => true,
  }

}
