# == Class: rally::settings::nova
#
# Configure Rally benchmarking settings for Nova
#
# === Parameters
#
# [*detach_volume_poll_interval*]
#   (Optional) Nova volume detach poll interval
#   Defaults to $::os_service_default
#
# [*detach_volume_timeout*]
#   (Optional) Nova volume detach timeout
#   Defaults to $::os_service_default
#
# [*server_boot_poll_interval*]
#   (Optional) Server boot poll interval
#   Defaults to $::os_service_default
#
# [*server_boot_prepoll_delay*]
#   (Optional) Time to sleep after boot before polling for status
#   Defaults to $::os_service_default
#
# [*server_boot_timeout*]
#   (Optional) Server boot timeout
#   Defaults to $::os_service_default
#
# [*server_delete_poll_interval*]
#   (Optional) Server delete poll interval
#   Defaults to $::os_service_default
#
# [*server_delete_prepoll_delay*]
#   (Optional) Time to sleep after delete before polling for status
#   Defaults to $::os_service_default
#
# [*server_delete_timeout*]
#   (Optional) Server delete timeout
#   Defaults to $::os_service_default
#
# [*server_image_create_poll_interval*]
#   (Optional) Server image_create poll interval
#   Defaults to $::os_service_default
#
# [*server_image_create_prepoll_delay*]
#   (Optional) Time to sleep after image_create before polling for status
#   Defaults to $::os_service_default
#
# [*server_image_create_timeout*]
#   (Optional) Server image_create timeout
#   Defaults to $::os_service_default
#
# [*server_image_delete_poll_interval*]
#   (Optional) Server image_delete poll interval
#   Defaults to $::os_service_default
#
# [*server_image_delete_prepoll_delay*]
#   (Optional) Time to sleep after image_delete before polling for status
#   Defaults to $::os_service_default
#
# [*server_image_delete_timeout*]
#   (Optional) Server image_delete timeout
#   Defaults to $::os_service_default
#
# [*server_live_migrate_poll_interval*]
#   (Optional) Server live_migrate poll interval
#   Defaults to $::os_service_default
#
# [*server_live_migrate_prepoll_delay*]
#   (Optional) Time to sleep after live_migrate before polling for status
#   Defaults to $::os_service_default
#
# [*server_live_migrate_timeout*]
#   (Optional) Server live_migrate timeout
#   Defaults to $::os_service_default
#
# [*server_migrate_poll_interval*]
#   (Optional) Server migrate poll interval
#   Defaults to $::os_service_default
#
# [*server_migrate_prepoll_delay*]
#   (Optional) Time to sleep after migrate before polling for status
#   Defaults to $::os_service_default
#
# [*server_migrate_timeout*]
#   (Optional) Server migrate timeout
#   Defaults to $::os_service_default
#
# [*server_pause_poll_interval*]
#   (Optional) Server pause poll interval
#   Defaults to $::os_service_default
#
# [*server_pause_prepoll_delay*]
#   (Optional) Time to sleep after pause before polling for status
#   Defaults to $::os_service_default
#
# [*server_pause_timeout*]
#   (Optional) Server pause timeout
#   Defaults to $::os_service_default
#
# [*server_reboot_poll_interval*]
#   (Optional) Server reboot poll interval
#   Defaults to $::os_service_default
#
# [*server_reboot_prepoll_delay*]
#   (Optional) Time to sleep after reboot before polling for status
#   Defaults to $::os_service_default
#
# [*server_reboot_timeout*]
#   (Optional) Server reboot timeout
#   Defaults to $::os_service_default
#
# [*server_rebuild_poll_interval*]
#   (Optional) Server rebuild poll interval
#   Defaults to $::os_service_default
#
# [*server_rebuild_prepoll_delay*]
#   (Optional) Time to sleep after rebuild before polling for status
#   Defaults to $::os_service_default
#
# [*server_rebuild_timeout*]
#   (Optional) Server rebuild timeout
#   Defaults to $::os_service_default
#
# [*server_rescue_poll_interval*]
#   (Optional) Server rescue poll interval
#   Defaults to $::os_service_default
#
# [*server_rescue_prepoll_delay*]
#   (Optional) Time to sleep after rescue before polling for status
#   Defaults to $::os_service_default
#
# [*server_rescue_timeout*]
#   (Optional) Server rescue timeout
#   Defaults to $::os_service_default
#
# [*server_resize_confirm_poll_interval*]
#   (Optional) Server resize_confirm poll interval
#   Defaults to $::os_service_default
#
# [*server_resize_confirm_prepoll_delay*]
#   (Optional) Time to sleep after resize_confirm before polling for status
#   Defaults to $::os_service_default
#
# [*server_resize_confirm_timeout*]
#   (Optional) Server resize_confirm timeout
#   Defaults to $::os_service_default
#
# [*server_resize_poll_interval*]
#   (Optional) Server resize poll interval
#   Defaults to $::os_service_default
#
# [*server_resize_prepoll_delay*]
#   (Optional) Time to sleep after resize before polling for status
#   Defaults to $::os_service_default
#
# [*server_resize_revert_poll_interval*]
#   (Optional) Server resize_revert poll interval
#   Defaults to $::os_service_default
#
# [*server_resize_revert_prepoll_delay*]
#   (Optional) Time to sleep after resize_revert before polling for status
#   Defaults to $::os_service_default
#
# [*server_resize_revert_timeout*]
#   (Optional) Server resize_revert timeout
#   Defaults to $::os_service_default
#
# [*server_resize_timeout*]
#   (Optional) Server resize timeout
#   Defaults to $::os_service_default
#
# [*server_resume_poll_interval*]
#   (Optional) Server resume poll interval
#   Defaults to $::os_service_default
#
# [*server_resume_prepoll_delay*]
#   (Optional) Time to sleep after resume before polling for status
#   Defaults to $::os_service_default
#
# [*server_resume_timeout*]
#   (Optional) Server resume timeout
#   Defaults to $::os_service_default
#
# [*server_shelve_poll_interval*]
#   (Optional) Server shelve poll interval
#   Defaults to $::os_service_default
#
# [*server_shelve_prepoll_delay*]
#   (Optional) Time to sleep after shelve before polling for status
#   Defaults to $::os_service_default
#
# [*server_shelve_timeout*]
#   (Optional) Server shelve timeout
#   Defaults to $::os_service_default
#
# [*server_start_poll_interval*]
#   (Optional) Server start poll interval
#   Defaults to $::os_service_default
#
# [*server_start_prepoll_delay*]
#   (Optional) Time to sleep after start before polling for status
#   Defaults to $::os_service_default
#
# [*server_start_timeout*]
#   (Optional) Server start timeout
#   Defaults to $::os_service_default
#
# [*server_stop_poll_interval*]
#   (Optional) Server stop poll interval
#   Defaults to $::os_service_default
#
# [*server_stop_prepoll_delay*]
#   (Optional) Time to sleep after stop before polling for status
#   Defaults to $::os_service_default
#
# [*server_stop_timeout*]
#   (Optional) Server stop timeout
#   Defaults to $::os_service_default
#
# [*server_suspend_poll_interval*]
#   (Optional) Server suspend poll interval
#   Defaults to $::os_service_default
#
# [*server_suspend_prepoll_delay*]
#   (Optional) Time to sleep after suspend before polling for status
#   Defaults to $::os_service_default
#
# [*server_suspend_timeout*]
#   (Optional) Server suspend timeout
#   Defaults to $::os_service_default
#
# [*server_unpause_poll_interval*]
#   (Optional) Server unpause poll interval
#   Defaults to $::os_service_default
#
# [*server_unpause_prepoll_delay*]
#   (Optional) Time to sleep after unpause before polling for status
#   Defaults to $::os_service_default
#
# [*server_unpause_timeout*]
#   (Optional) Server unpause timeout
#   Defaults to $::os_service_default
#
# [*server_unrescue_poll_interval*]
#   (Optional) Server unrescue poll interval
#   Defaults to $::os_service_default
#
# [*server_unrescue_prepoll_delay*]
#   (Optional) Time to sleep after unrescue before polling for status
#   Defaults to $::os_service_default
#
# [*server_unrescue_timeout*]
#   (Optional) Server unrescue timeout
#   Defaults to $::os_service_default
#
# [*server_unshelve_poll_interval*]
#   (Optional) Server unshelve poll interval
#   Defaults to $::os_service_default
#
# [*server_unshelve_prepoll_delay*]
#   (Optional) Time to sleep after unshelve before polling for status
#   Defaults to $::os_service_default
#
# [*server_unshelve_timeout*]
#   (Optional) Server unshelve timeout
#   Defaults to $::os_service_default
#
# [*vm_ping_poll_interval*]
#   (Optional) Interval between checks when waiting for a VM to become pingable
#   Defaults to $::os_service_default
#
# [*vm_ping_timeout*]
#   (Optional) Time to wait for a VM to become pingable
#   Defaults to $::os_service_default
#
class rally::settings::nova (
  $detach_volume_poll_interval         = $::os_service_default,
  $detach_volume_timeout               = $::os_service_default,
  $server_boot_poll_interval           = $::os_service_default,
  $server_boot_prepoll_delay           = $::os_service_default,
  $server_boot_timeout                 = $::os_service_default,
  $server_delete_poll_interval         = $::os_service_default,
  $server_delete_prepoll_delay         = $::os_service_default,
  $server_delete_timeout               = $::os_service_default,
  $server_image_create_poll_interval   = $::os_service_default,
  $server_image_create_prepoll_delay   = $::os_service_default,
  $server_image_create_timeout         = $::os_service_default,
  $server_image_delete_poll_interval   = $::os_service_default,
  $server_image_delete_prepoll_delay   = $::os_service_default,
  $server_image_delete_timeout         = $::os_service_default,
  $server_live_migrate_poll_interval   = $::os_service_default,
  $server_live_migrate_prepoll_delay   = $::os_service_default,
  $server_live_migrate_timeout         = $::os_service_default,
  $server_migrate_poll_interval        = $::os_service_default,
  $server_migrate_prepoll_delay        = $::os_service_default,
  $server_migrate_timeout              = $::os_service_default,
  $server_pause_poll_interval          = $::os_service_default,
  $server_pause_prepoll_delay          = $::os_service_default,
  $server_pause_timeout                = $::os_service_default,
  $server_reboot_poll_interval         = $::os_service_default,
  $server_reboot_prepoll_delay         = $::os_service_default,
  $server_reboot_timeout               = $::os_service_default,
  $server_rebuild_poll_interval        = $::os_service_default,
  $server_rebuild_prepoll_delay        = $::os_service_default,
  $server_rebuild_timeout              = $::os_service_default,
  $server_rescue_poll_interval         = $::os_service_default,
  $server_rescue_prepoll_delay         = $::os_service_default,
  $server_rescue_timeout               = $::os_service_default,
  $server_resize_confirm_poll_interval = $::os_service_default,
  $server_resize_confirm_prepoll_delay = $::os_service_default,
  $server_resize_confirm_timeout       = $::os_service_default,
  $server_resize_poll_interval         = $::os_service_default,
  $server_resize_prepoll_delay         = $::os_service_default,
  $server_resize_revert_poll_interval  = $::os_service_default,
  $server_resize_revert_prepoll_delay  = $::os_service_default,
  $server_resize_revert_timeout        = $::os_service_default,
  $server_resize_timeout               = $::os_service_default,
  $server_resume_poll_interval         = $::os_service_default,
  $server_resume_prepoll_delay         = $::os_service_default,
  $server_resume_timeout               = $::os_service_default,
  $server_shelve_poll_interval         = $::os_service_default,
  $server_shelve_prepoll_delay         = $::os_service_default,
  $server_shelve_timeout               = $::os_service_default,
  $server_start_poll_interval          = $::os_service_default,
  $server_start_prepoll_delay          = $::os_service_default,
  $server_start_timeout                = $::os_service_default,
  $server_stop_poll_interval           = $::os_service_default,
  $server_stop_prepoll_delay           = $::os_service_default,
  $server_stop_timeout                 = $::os_service_default,
  $server_suspend_poll_interval        = $::os_service_default,
  $server_suspend_prepoll_delay        = $::os_service_default,
  $server_suspend_timeout              = $::os_service_default,
  $server_unpause_poll_interval        = $::os_service_default,
  $server_unpause_prepoll_delay        = $::os_service_default,
  $server_unpause_timeout              = $::os_service_default,
  $server_unrescue_poll_interval       = $::os_service_default,
  $server_unrescue_prepoll_delay       = $::os_service_default,
  $server_unrescue_timeout             = $::os_service_default,
  $server_unshelve_poll_interval       = $::os_service_default,
  $server_unshelve_prepoll_delay       = $::os_service_default,
  $server_unshelve_timeout             = $::os_service_default,
  $vm_ping_poll_interval               = $::os_service_default,
  $vm_ping_timeout                     = $::os_service_default,
) {

  include ::rally::deps

  rally_config {
    'benchmark/nova_detach_volume_poll_interval':          value => $detach_volume_poll_interval;
    'benchmark/nova_detach_volume_timeout':                value => $detach_volume_timeout;
    'benchmark/nova_server_boot_poll_interval':            value => $server_boot_poll_interval;
    'benchmark/nova_server_boot_prepoll_delay':            value => $server_boot_prepoll_delay;
    'benchmark/nova_server_boot_timeout':                  value => $server_boot_timeout;
    'benchmark/nova_server_delete_poll_interval':          value => $server_delete_poll_interval;
    'benchmark/nova_server_delete_prepoll_delay':          value => $server_delete_prepoll_delay;
    'benchmark/nova_server_delete_timeout':                value => $server_delete_timeout;
    'benchmark/nova_server_image_create_poll_interval':    value => $server_image_create_poll_interval;
    'benchmark/nova_server_image_create_prepoll_delay':    value => $server_image_create_prepoll_delay;
    'benchmark/nova_server_image_create_timeout':          value => $server_image_create_timeout;
    'benchmark/nova_server_image_delete_poll_interval':    value => $server_image_delete_poll_interval;
    'benchmark/nova_server_image_delete_prepoll_delay':    value => $server_image_delete_prepoll_delay;
    'benchmark/nova_server_image_delete_timeout':          value => $server_image_delete_timeout;
    'benchmark/nova_server_live_migrate_poll_interval':    value => $server_live_migrate_poll_interval;
    'benchmark/nova_server_live_migrate_prepoll_delay':    value => $server_live_migrate_prepoll_delay;
    'benchmark/nova_server_live_migrate_timeout':          value => $server_live_migrate_timeout;
    'benchmark/nova_server_migrate_poll_interval':         value => $server_migrate_poll_interval;
    'benchmark/nova_server_migrate_prepoll_delay':         value => $server_migrate_prepoll_delay;
    'benchmark/nova_server_migrate_timeout':               value => $server_migrate_timeout;
    'benchmark/nova_server_pause_poll_interval':           value => $server_pause_poll_interval;
    'benchmark/nova_server_pause_prepoll_delay':           value => $server_pause_prepoll_delay;
    'benchmark/nova_server_pause_timeout':                 value => $server_pause_timeout;
    'benchmark/nova_server_reboot_poll_interval':          value => $server_reboot_poll_interval;
    'benchmark/nova_server_reboot_prepoll_delay':          value => $server_reboot_prepoll_delay;
    'benchmark/nova_server_reboot_timeout':                value => $server_reboot_timeout;
    'benchmark/nova_server_rebuild_poll_interval':         value => $server_rebuild_poll_interval;
    'benchmark/nova_server_rebuild_prepoll_delay':         value => $server_rebuild_prepoll_delay;
    'benchmark/nova_server_rebuild_timeout':               value => $server_rebuild_timeout;
    'benchmark/nova_server_rescue_poll_interval':          value => $server_rescue_poll_interval;
    'benchmark/nova_server_rescue_prepoll_delay':          value => $server_rescue_prepoll_delay;
    'benchmark/nova_server_rescue_timeout':                value => $server_rescue_timeout;
    'benchmark/nova_server_resize_confirm_poll_interval':  value => $server_resize_confirm_poll_interval;
    'benchmark/nova_server_resize_confirm_prepoll_delay':  value => $server_resize_confirm_prepoll_delay;
    'benchmark/nova_server_resize_confirm_timeout':        value => $server_resize_confirm_timeout;
    'benchmark/nova_server_resize_poll_interval':          value => $server_resize_poll_interval;
    'benchmark/nova_server_resize_prepoll_delay':          value => $server_resize_prepoll_delay;
    'benchmark/nova_server_resize_revert_poll_interval':   value => $server_resize_revert_poll_interval;
    'benchmark/nova_server_resize_revert_prepoll_delay':   value => $server_resize_revert_prepoll_delay;
    'benchmark/nova_server_resize_revert_timeout':         value => $server_resize_revert_timeout;
    'benchmark/nova_server_resize_timeout':                value => $server_resize_timeout;
    'benchmark/nova_server_resume_poll_interval':          value => $server_resume_poll_interval;
    'benchmark/nova_server_resume_prepoll_delay':          value => $server_resume_prepoll_delay;
    'benchmark/nova_server_resume_timeout':                value => $server_resume_timeout;
    'benchmark/nova_server_shelve_poll_interval':          value => $server_shelve_poll_interval;
    'benchmark/nova_server_shelve_prepoll_delay':          value => $server_shelve_prepoll_delay;
    'benchmark/nova_server_shelve_timeout':                value => $server_shelve_timeout;
    'benchmark/nova_server_start_poll_interval':           value => $server_start_poll_interval;
    'benchmark/nova_server_start_prepoll_delay':           value => $server_start_prepoll_delay;
    'benchmark/nova_server_start_timeout':                 value => $server_start_timeout;
    'benchmark/nova_server_stop_poll_interval':            value => $server_stop_poll_interval;
    'benchmark/nova_server_stop_prepoll_delay':            value => $server_stop_prepoll_delay;
    'benchmark/nova_server_stop_timeout':                  value => $server_stop_timeout;
    'benchmark/nova_server_suspend_poll_interval':         value => $server_suspend_poll_interval;
    'benchmark/nova_server_suspend_prepoll_delay':         value => $server_suspend_prepoll_delay;
    'benchmark/nova_server_suspend_timeout':               value => $server_suspend_timeout;
    'benchmark/nova_server_unpause_poll_interval':         value => $server_unpause_poll_interval;
    'benchmark/nova_server_unpause_prepoll_delay':         value => $server_unpause_prepoll_delay;
    'benchmark/nova_server_unpause_timeout':               value => $server_unpause_timeout;
    'benchmark/nova_server_unrescue_poll_interval':        value => $server_unrescue_poll_interval;
    'benchmark/nova_server_unrescue_prepoll_delay':        value => $server_unrescue_prepoll_delay;
    'benchmark/nova_server_unrescue_timeout':              value => $server_unrescue_timeout;
    'benchmark/nova_server_unshelve_poll_interval':        value => $server_unshelve_poll_interval;
    'benchmark/nova_server_unshelve_prepoll_delay':        value => $server_unshelve_prepoll_delay;
    'benchmark/nova_server_unshelve_timeout':              value => $server_unshelve_timeout;
    'benchmark/vm_ping_poll_interval':                     value => $vm_ping_poll_interval;
    'benchmark/vm_ping_timeout':                           value => $vm_ping_timeout;
  }
}
