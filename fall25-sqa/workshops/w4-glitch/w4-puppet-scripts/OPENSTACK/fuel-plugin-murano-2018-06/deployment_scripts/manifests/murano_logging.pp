notice('MURANO PLUGIN: murano_logging.pp')

$content=':syslogtag, contains, "murano" -/var/log/murano-all.log
### stop further processing for the matched entries
& ~'

include ::rsyslog::params

::rsyslog::snippet { '55-murano':
  content => $content,
}

Rsyslog::Snippet['55-murano'] ~> Service[$::rsyslog::params::service_name]
