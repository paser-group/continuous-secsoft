notice('MURANO PLUGIN: import_murano_package.pp')

murano::application { 'io.murano' :
  exists_action => 'u'
}
murano::application { 'io.murano.applications' :
  exists_action => 'u'
}
