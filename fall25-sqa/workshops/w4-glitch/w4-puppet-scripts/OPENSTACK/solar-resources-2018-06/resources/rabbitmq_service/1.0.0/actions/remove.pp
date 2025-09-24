$resource = hiera($::resource_name)

class { '::rabbitmq':
  package_ensure    => 'absent',
  environment_variables   => {
    'RABBITMQ_SERVICENAME'  => 'RabbitMQ'
  }
}

