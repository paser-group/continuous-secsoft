class platform::armada::params(
  $node_selector_label = 'armada=enabled'
) {}

class platform::armada
  inherits ::platform::armada::params {
  include ::platform::params

  if (str2bool($::is_initial_config) and $::personality == 'controller') {

    Class['::platform::kubernetes::master']

    # Configure sane node label values that work with armada node selector.
    # This is a workaround for helm v3 increased chart validation of values.
    # We cannot override armada .Values.labels.node_selector_value with null
    # or "" since it produces:
    # error validating "": error validating data: unknown object type "nil".
    # We can override with "" if the chart is modified to quote the value.
    -> exec { 'label for armada node selector':
      path      => '/usr/bin:/usr/sbin:/bin',
      command   => "kubectl --kubeconfig=/etc/kubernetes/admin.conf label node ${::platform::params::hostname} armada=enabled || true", # lint:ignore:140chars
      logoutput => true,
    }
  }
}
