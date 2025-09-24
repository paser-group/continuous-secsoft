# == Define: concat
#
# Sets up so that you can use fragments to build a final config file,
#
# === Options:
#
# [*path*]
#   The path to the final file. Use this in case you want to differentiate
#   between the name of a resource and the file path.  Note: Use the name you
#   provided in the target of your fragments.
# [*mode*]
#   The mode of the final file
# [*owner*]
#   Who will own the file
# [*group*]
#   Who will own the file
# [*force*]
#   Enables creating empty files if no fragments are present
# [*warn*]
#   Adds a normal shell style comment top of the file indicating that it is
#   built by puppet
# [*backup*]
#   Controls the filebucketing behavior of the final file and see File type
#   reference for its use.  Defaults to 'puppet'
# [*replace*]
#   Whether to replace a file that already exists on the local system
#
# === Actions:
# * Creates fragment directories if it didn't exist already
# * Executes the concatfragments.rb script to build the final file, this
#   script will create directory/fragments.concat.   Execution happens only
#   when:
#   * The directory changes
#   * fragments.concat != final destination, this means rebuilds will happen
#     whenever someone changes or deletes the final file.  Checking is done
#     using /usr/bin/cmp.
#   * The Exec gets notified by something else - like the concat::fragment
#     define
# * Copies the file over to the final destination using a file resource
#
# === Aliases:
#
# * The exec can notified using Exec["concat_/path/to/file"] or
#   Exec["concat_/path/to/directory"]
# * The final file can be referened as File["/path/to/file"] or
#   File["concat_/path/to/file"]
#
define concat(
  $path = $name,
  $owner = $::id,
  $group = $concat::setup::root_group,
  $mode = undef,
  $warn = false,
  $force = false,
  $backup = 'puppet',
  $replace = true,
  $gnu = undef,
  $order='alpha'
) {
  include concat::setup

  $safe_name   = regsubst($name, $concat::setup::pathchars, '_', 'G')
  $concatdir   = $concat::setup::concatdir
  $version     = $concat::setup::majorversion
  $fragdir     = "${concatdir}/${safe_name}"
  $concat_name = 'fragments.concat.out'
  $default_warn_message = '# This file is managed by Puppet. DO NOT EDIT.'

  case $warn {
    'true', true, yes, on: {
      $warnmsg = $default_warn_message
    }
    'false', false, no, off: {
      $warnmsg = ''
    }
    default: {
      $warnmsg = $warn
    }
  }

  $warnmsg_escaped = regsubst($warnmsg, "'", "'\\\\''", 'G')
  $warnflag = $warnmsg_escaped ? {
    ''      => '',
    default => "-w '${warnmsg_escaped}'"
  }

  case $force {
    'true', true, yes, on: {
      $forceflag = '-f'
    }
    'false', false, no, off: {
      $forceflag = ''
    }
    default: {
      fail("Improper 'force' value given to concat: ${force}")
    }
  }

  case $order {
    numeric: {
      $orderflag = '-n'
    }
    alpha: {
      $orderflag = ''
    }
    default: {
      fail("Improper 'order' value given to concat: ${order}")
    }
  }

  File {
    owner   => $::id,
    group   => $group,
    mode    => $mode,
    backup  => $backup,
    replace => $replace
  }

  file { $fragdir:
    ensure => directory,
    mode   => "0775",
  }

  $source_real = $version ? {
    24      => 'puppet:///concat/null',
    default => undef,
  }

  file { "${fragdir}/fragments":
    ensure   => directory,
    mode     => "0775",
    force    => true,
    ignore   => ['.svn', '.git', '.gitignore'],
    notify   => Exec["concat_${name}"],
    purge    => true,
    recurse  => true,
    source   => $source_real,
  }

  file { "${fragdir}/fragments.concat":
    ensure   => present,
    mode     => "0664",
  }

  file { "${fragdir}/${concat_name}":
    ensure   => present,
    mode     => "0664",
  }

  file { $name:
    ensure   => present,
    path     => $path,
    alias    => "concat_${name}",
    group    => $group,
    mode     => $mode,
    owner    => $owner,
    source   => "${fragdir}/${concat_name}",
  }

  exec { "concat_${name}":
    alias       => "concat_${fragdir}",
    command     => "\"${::concat_ruby_interpreter}\" ${concat::setup::concatdir}/bin/concatfragments.rb -o ${fragdir}/${concat_name} -d ${fragdir} ${warnflag} ${forceflag} ${orderflag}",
    notify      => File[$name],
    logoutput   => on_failure,
    require     => [
      File[$fragdir],
      File["${fragdir}/fragments"],
      File["${fragdir}/${concat_name}"],
      File["${fragdir}/fragments.concat"],
    ],
    subscribe   => File[$fragdir],
    unless      => "\"${::concat_ruby_interpreter}\" ${concat::setup::concatdir}/bin/concatfragments.rb -o ${fragdir}/${concat_name} -d ${fragdir} -t ${warnflag} ${forceflag} ${orderflag}",
  }

  if $::id == 'root' {
    Exec["concat_${name}"] {
      user  => root,
      group => $group,
    }
  }
}

# vim:sw=2:ts=2:expandtab:textwidth=79
