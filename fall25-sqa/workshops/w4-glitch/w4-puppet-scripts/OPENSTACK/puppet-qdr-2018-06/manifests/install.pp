# == Class qdr::install
#
# This class is called from qdr for qdrouterd service installation
#
# === Parameters
#
# [*ensure_package*]
#   (optional) The state of the qdr packages
#   Defaults to  $::qdr::ensure_package
#
# [*service_package_name*]
#   (optional) The service package name for osfamily
#   Defaults to $::qdr::params::service_package_name
#
# [*package_provider*]
#   (optional) The package repo application for osfamily
#   Defaults to $::qdr::params::package_provider
#
# [*sasl_package_list*]
#   (optional) The sasl package enumeration for osfamily
#   Defaults to $::qdr::params::sasl_package_list
#
# [*tools_package_list*]
#   (optional) The qdr tools package enumeration for osfamily
#   Defaults to $::qdr::params::tools_package_list
#
class qdr::install (
  $ensure_package       = $::qdr::ensure_package,
  $service_package_name = $::qdr::params::service_package_name,
  $package_provider     = $::qdr::params::package_provider,
  $sasl_package_list    = $::qdr::params::sasl_package_list,
  $tools_package_list   = $::qdr::params::tools_package_list,
) inherits qdr {

  package { $sasl_package_list :
    ensure   => $ensure_package,
    provider => $package_provider,
  }

  package { $service_package_name :
    ensure   => $ensure_package,
    provider => $package_provider,
    notify   => Class['qdr::service'],
    require  => Package[$sasl_package_list],
  }

  package { $tools_package_list :
    ensure   => $ensure_package,
    provider => $package_provider,
    require  => Package[$service_package_name],
  }

}
