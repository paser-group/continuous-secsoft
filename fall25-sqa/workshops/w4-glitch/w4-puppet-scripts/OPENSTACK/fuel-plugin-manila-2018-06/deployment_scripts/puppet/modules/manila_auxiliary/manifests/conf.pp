class manila_auxiliary::conf (
  $default_share_type = 'default_share_type',
  ) {
  manila_config {
    'DEFAULT/default_share_type':      value => $default_share_type;
    'DEFAULT/osapi_share_extension':   value => 'manila.api.contrib.standard_extensions';
    'DEFAULT/enabled_share_protocols': value => 'NFS,CIFS';
    'DEFAULT/share_name_template':     value => 'share-%s';
  }
  }
