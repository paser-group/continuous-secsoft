# == Define: oslo::cache
#
# Configure oslo.cache options
#
# This resource configures Oslo cache resources for an OpenStack service.
# It will manage the [cache] section in the given config resource.
# It supports all of the oslo.cache parameters specified at
# https://github.com/openstack/oslo.cache/blob/master/oslo_cache/_opts.py
#
# For example, when configuring glance cache, instead of doing this:
#
#     glance_api_config {
#       'cache/memcached_servers':   value => $memcached_servers;
#       'cache/memcache_dead_retry': value => $memcache_dead_retry;
#       ...
#     }
#
# manifests should do this instead::
#
#    oslo::cache { 'glance_api_config':
#      memcached_servers   => $memcached_servers,
#      memcache_dead_retry => $memcache_dead_retry,
#      ...
#    }
#
# or add following code in glance::api:
#
#    create_resources(oslo::cache, $cache_config)
#
# Then in hiera should add this:
#
#   glance::api::cache_config:
#     'glance_api_config':
#       memcached_servers: '127.0.0.1'
#       memcache_dead_retry: '100'
#
# === Parameters:
#
# [*config_prefix*]
#   (Optional) Prefix for building the configuration dictionary for
#   the cache region. This should not need to be changed unless there
#   is another dogpile.cache region with the same configuration name.
#   (string value)
#   Defaults to $::os_service_default
#
# [*expiration_time*]
#   (Optional) Default TTL, in seconds, for any cached item in the
#   dogpile.cache region. This applies to any cached method that
#   doesn't have an explicit cache expiration time defined for it.
#   (integer value)
#   Defaults to $::os_service_default
#
# [*backend*]
#   (Optional) Dogpile.cache backend module. It is recommended that
#   Memcache with pooling (oslo_cache.memcache_pool) or Redis
#   (dogpile.cache.redis) be used in production deployments. (string value)
#   Defaults to $::os_service_default
#
# [*backend_argument*]
#   (Optional) Arguments supplied to the backend module. Specify this option
#   once per argument to be passed to the dogpile.cache backend.
#   Example format: "<argname>:<value>". (list value)
#   Defaults to $::os_service_default
#
# [*proxies*]
#   (Optional) Proxy classes to import that will affect the way the
#   dogpile.cache backend functions. See the dogpile.cache documentation on
#   changing-backend-behavior. (list value)
#   Defaults to $::os_service_default
#
# [*enabled*]
#   (Optional) Global toggle for caching. (boolean value)
#   Defaults to $::os_service_default
#
# [*debug_cache_backend*]
#   (Optional) Extra debugging from the cache backend (cache keys,
#   get/set/delete/etc calls). This is only really useful if you need
#   to see the specific cache-backend get/set/delete calls with the keys/values.
#   Typically this should be left set to false. (boolean value)
#   Defaults to $::os_service_default
#
# [*memcache_servers*]
#   (Optional) Memcache servers in the format of "host:port".
#   (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).
#   (list value)
#   Defaults to $::os_service_default
#
# [*memcache_dead_retry*]
#   (Optional) Number of seconds memcached server is considered dead before
#   it is tried again. (dogpile.cache.memcache and oslo_cache.memcache_pool
#   backends only). (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_socket_timeout*]
#   (Optional) Timeout in seconds for every call to a server.
#   (dogpile.cache.memcache and oslo_cache.memcache_pool backends only).
#   (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_pool_maxsize*]
#   Max total number of open connections to every memcached server.
#   (oslo_cache.memcache_pool backend only). (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_pool_unused_timeout*]
#   (Optional) Number of seconds a connection to memcached is held unused
#   in the pool before it is closed. (oslo_cache.memcache_pool backend only)
#   (integer value)
#   Defaults to $::os_service_default
#
# [*memcache_pool_connection_get_timeout*]
#   (Optional) Number of seconds that an operation will wait to get a memcache
#   client connection. (integer value)
#   Defaults to $::os_service_default
#
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package.
#   Defaults to true.
#
define oslo::cache(
  $config_prefix                        = $::os_service_default,
  $expiration_time                      = $::os_service_default,
  $backend                              = $::os_service_default,
  $backend_argument                     = $::os_service_default,
  $proxies                              = $::os_service_default,
  $enabled                              = $::os_service_default,
  $debug_cache_backend                  = $::os_service_default,
  $memcache_servers                     = $::os_service_default,
  $memcache_dead_retry                  = $::os_service_default,
  $memcache_socket_timeout              = $::os_service_default,
  $memcache_pool_maxsize                = $::os_service_default,
  $memcache_pool_unused_timeout         = $::os_service_default,
  $memcache_pool_connection_get_timeout = $::os_service_default,
  $manage_backend_package               = true,
){

  include ::oslo::params

  if !is_service_default($backend_argument) {
    $backend_argument_orig = join(any2array($backend_argument), ',')
  } else {
    $backend_argument_orig = $backend_argument
  }

  if !is_service_default($memcache_servers) {
    $memcache_servers_orig = join(any2array($memcache_servers), ',')
  } else {
    $memcache_servers_orig = $memcache_servers
  }

  if !is_service_default($proxies) {
    $proxies_orig = join(any2array($proxies), ',')
  } else {
    $proxies_orig = $proxies
  }

  if $manage_backend_package {
    if ($backend =~ /pylibmc/ ) {
      ensure_packages('python-pylibmc', {
        ensure => present,
        name   => $::oslo::params::pylibmc_package_name,
        tag    => 'openstack',
      })
    } elsif ($backend =~ /\.memcache/ ) {
      ensure_resources('package', { 'python-memcache' => {
        name   => $::oslo::params::python_memcache_package_name,
        tag    => ['openstack'],
      }})
    }
  }

  $cache_options = {
    'cache/config_prefix'                        => { value => $config_prefix },
    'cache/expiration_time'                      => { value => $expiration_time },
    'cache/backend'                              => { value => $backend },
    'cache/backend_argument'                     => { value => $backend_argument_orig },
    'cache/proxies'                              => { value => $proxies_orig },
    'cache/enabled'                              => { value => $enabled },
    'cache/debug_cache_backend'                  => { value => $debug_cache_backend },
    'cache/memcache_servers'                     => { value => $memcache_servers_orig },
    'cache/memcache_dead_retry'                  => { value => $memcache_dead_retry },
    'cache/memcache_socket_timeout'              => { value => $memcache_socket_timeout },
    'cache/memcache_pool_maxsize'                => { value => $memcache_pool_maxsize },
    'cache/memcache_pool_unused_timeout'         => { value => $memcache_pool_unused_timeout },
    'cache/memcache_pool_connection_get_timeout' => { value => $memcache_pool_connection_get_timeout },
  }

  create_resources($name, $cache_options)
}
