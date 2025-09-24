# == Class: rally::settings::heat
#
# Configure Rally benchmarking settings for Heat
#
# === Parameters
#
# [*stack_check_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   checking.
#   Defaults to $::os_service_default
#
# [*stack_check_timeout*]
#   (Optional) Time (in sec) to wait for stack to be checked.
#   Defaults to $::os_service_default
#
# [*stack_create_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   creation.
#   Defaults to $::os_service_default
#
# [*stack_create_prepoll_delay*]
#   (Optional) Time (in sec) to sleep after creating a resource before polling
#   for it status.
#   Defaults to $::os_service_default
#
# [*stack_create_timeout*]
#   (Optional) Time (in sec) to wait for heat stack to be created.
#   Defaults to $::os_service_default
#
# [*stack_delete_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   deletion.
#   Defaults to $::os_service_default
#
# [*stack_delete_timeout*]
#   (Optional) Time (in sec) to wait for heat stack to be deleted.
#   Defaults to $::os_service_default
#
# [*stack_owner_role*]
#   (Optional) Role required for users to be able to manage Heat stacks
#   Defaults to $::os_service_default
#
# [*stack_restore_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack to
#   be restored.
#   Defaults to $::os_service_default
#
# [*stack_restore_timeout*]
#   (Optional) Time (in sec) to wait for stack to be restored from snapshot.
#   Defaults to $::os_service_default
#
# [*stack_resume_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   resume.
#   Defaults to $::os_service_default
#
# [*stack_resume_timeout*]
#   (Optional) Time (in sec) to wait for stack to be resumed.
#   Defaults to $::os_service_default
#
# [*stack_scale_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for a stack
#   to scale up or down.
#   Defaults to $::os_service_default
#
# [*stack_scale_timeout*]
#   (Optional) Time (in sec) to wait for stack to scale up or down.
#   Defaults to $::os_service_default
#
# [*stack_snapshot_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   snapshot to be created.
#   Defaults to $::os_service_default
#
# [*stack_snapshot_timeout*]
#   (Optional) Time (in sec) to wait for stack snapshot to be created.
#   Defaults to $::os_service_default
#
# [*stack_suspend_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   suspend.
#   Defaults to $::os_service_default
#
# [*stack_suspend_timeout*]
#   (Optional) Time (in sec) to wait for stack to be suspended.
#   Defaults to $::os_service_default
#
# [*stack_update_poll_interval*]
#   (Optional) Time interval (in sec) between checks when waiting for stack
#   update.
#   Defaults to $::os_service_default
#
# [*stack_update_prepoll_delay*]
#   (Optional) Time (in sec) to sleep after updating a resource before polling
#   for it status.
#   Defaults to $::os_service_default
#
# [*stack_update_timeout*]
#   (Optional) Time (in sec) to wait for stack to be updated.
#   Defaults to $::os_service_default
#
# [*stack_user_role*]
#   (Optional) Role for Heat template-defined users
#   Defaults to $::os_service_default
#
class rally::settings::heat (
  $stack_check_poll_interval   = $::os_service_default,
  $stack_check_timeout         = $::os_service_default,
  $stack_create_poll_interval  = $::os_service_default,
  $stack_create_prepoll_delay  = $::os_service_default,
  $stack_create_timeout        = $::os_service_default,
  $stack_delete_poll_interval  = $::os_service_default,
  $stack_delete_timeout        = $::os_service_default,
  $stack_owner_role            = $::os_service_default,
  $stack_restore_poll_interval = $::os_service_default,
  $stack_restore_timeout       = $::os_service_default,
  $stack_resume_poll_interval  = $::os_service_default,
  $stack_resume_timeout        = $::os_service_default,
  $stack_scale_poll_interval   = $::os_service_default,
  $stack_scale_timeout         = $::os_service_default,
  $stack_snapshot_poll_interval= $::os_service_default,
  $stack_snapshot_timeout      = $::os_service_default,
  $stack_suspend_poll_interval = $::os_service_default,
  $stack_suspend_timeout       = $::os_service_default,
  $stack_update_poll_interval  = $::os_service_default,
  $stack_update_prepoll_delay  = $::os_service_default,
  $stack_update_timeout        = $::os_service_default,
  $stack_user_role             = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/heat_stack_check_poll_interval':    value => $stack_check_poll_interval;
    'benchmark/heat_stack_check_timeout':          value => $stack_check_timeout;
    'benchmark/heat_stack_create_poll_interval':   value => $stack_create_poll_interval;
    'benchmark/heat_stack_create_prepoll_delay':   value => $stack_create_prepoll_delay;
    'benchmark/heat_stack_create_timeout':         value => $stack_create_timeout;
    'benchmark/heat_stack_delete_poll_interval':   value => $stack_delete_poll_interval;
    'benchmark/heat_stack_delete_timeout':         value => $stack_delete_timeout;
    'benchmark/heat_stack_restore_poll_interval':  value => $stack_restore_poll_interval;
    'benchmark/heat_stack_restore_timeout':        value => $stack_restore_timeout;
    'benchmark/heat_stack_resume_poll_interval':   value => $stack_resume_poll_interval;
    'benchmark/heat_stack_resume_timeout':         value => $stack_resume_timeout;
    'benchmark/heat_stack_scale_poll_interval':    value => $stack_scale_poll_interval;
    'benchmark/heat_stack_scale_timeout':          value => $stack_scale_timeout;
    'benchmark/heat_stack_snapshot_poll_interval': value => $stack_snapshot_poll_interval;
    'benchmark/heat_stack_snapshot_timeout':       value => $stack_snapshot_timeout;
    'benchmark/heat_stack_suspend_poll_interval':  value => $stack_suspend_poll_interval;
    'benchmark/heat_stack_suspend_timeout':        value => $stack_suspend_timeout;
    'benchmark/heat_stack_update_poll_interval':   value => $stack_update_poll_interval;
    'benchmark/heat_stack_update_prepoll_delay':   value => $stack_update_prepoll_delay;
    'benchmark/heat_stack_update_timeout':         value => $stack_update_timeout;
    'role/heat_stack_owner_role':                  value => $stack_owner_role;
    'role/heat_stack_user_role':                   value => $stack_user_role;
  }
}
