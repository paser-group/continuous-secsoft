notice('MURANO PLUGIN: murano_disable_old.pp')

define stop_service(
  $service_name = $name,
) {
  exec { "stop ${name}":
    command => "/usr/sbin/service ${service_name} stop || true",
    onlyif => "/usr/sbin/service ${service_name} status",
  }
}

include ::murano::params
$murano_services = [ $::murano::params::api_service_name ,
                     $::murano::params::engine_service_name ,
                     $::murano::params::cfapi_service_name ,
                     'murano-rabbitmq' ]

stop_service { $murano_services: }
