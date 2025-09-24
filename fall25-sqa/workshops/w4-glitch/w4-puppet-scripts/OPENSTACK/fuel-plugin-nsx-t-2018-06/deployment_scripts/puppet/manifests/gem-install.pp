notice('fuel-plugin-nsx-t: gem-install.pp')

# ruby gem package must be pre installed before puppet module used
package { ['ruby-json', 'ruby-rest-client']:
  ensure => latest,
}
