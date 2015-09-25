# == Class: vmware_workstation
#
# Install and configure VMware Workstation.
#
# Requires module wget to download installation file.
# https://forge.puppetlabs.com/maestrodev/wget
#
# === Parameters
#
# [*ensure*]
# Must be 'installed' or 'absent'.
#
# [*serial_number*]
# Optional. Set the serial number for VMware Workstation. If this is left
# blank then VMware Workstation will expire after 30 days. A warning
# is issued during installation.
#
# [*url*]
# Optional. URL to download VMware workstation from.
# Defaults to https://download3.vmware.com/software/wkst/file/
#
# [*version*]
# Optional. Version of VMware Workstation to download.
# Default 11.1.0-2496824
#
# [*cache_dir*]
# Optional. Wget will keep a cached copy of the installer on the server and
# only re-download if the date/time stamp of the source changes.
# Default /var/cache/wget
#
# [*destination*]
# Optional. Save location for wget to save installer to.
# Default /tmp/
#
# [*filename*]
# Optional. Name of the VMware Workstation installer to download.
# Default VMware-Workstation-Full-${version}.${::architecture}.bundle or
# VMware-workstation-full-${version}.exe
#
# [*install_options*]
# Optional. Installation options for VMware Workstation. See VMware
# documentation.
# Default silent install, accept EULA, ignore errors.
#
# === Variables
#
# [*source*]
# Full URI to source file to download.
#
# [*install_command*]
# Fully qualified installation command used to install VMware Workstation.
#
# [*uninstall_command*]
# Fully qualified uninstallation command used to uninstall VMware Workstation.
#
# === Examples
#
#  class { 'vmware_workstation':
#   ensure  => installed,
#  }
#
# === Authors
#
# Mike Marseglia <mike@marseglia.org>
#
# === Copyright
#
# Copyright 2015 Mike Marseglia, unless otherwise noted.
#
class vmware_workstation (
  $ensure             = 'installed',
  $serial_number      = UNDEF,
  $url                = $::vmware_workstation::params::url,
  $version            = $::vmware_workstation::params::version,
  $cache_dir          = $::vmware_workstation::params::cache_dir,
  $destination        = $::vmware_workstation::params::destination,
  $filename           = $::vmware_workstation::params::filename,
  $install_command    = $::vmware_workstation::params::install_command,
  $install_options    = $::vmware_workstation::params::install_options,
  $uninstall_command  = $::vmware_workstation::params::uninstall_command,
) inherits vmware_workstation::params {

  if $::architecture != 'x86_64' {
    fail("VMware Workstation requires a 64-bit operating system. Architecture ${::architecture} reported.")
  }

  # convert total memory to a number for comparison
  $_memorysize_mb = $::memorysize_mb * 1
  if $_memorysize_mb < 2000 {
    fail("VMware Workstation requires at least 2GB of memory. Memory ${::memorysize} reported.")
  }

  validate_string($ensure)
  validate_string($url)
  validate_string($version)
  validate_absolute_path($cache_dir)
  validate_absolute_path($destination)
  validate_string($filename)
  validate_string($install_options)

  $source = "${url}${filename}"

  case $ensure {
    'installed' : {
      archive{ 'vmware_workstation':
        ensure       => present,
        extract      => false,
        extract_path => $destination,
        source       => $source,
        creates      => '/usr/bin/vmware',
      }

      exec { 'install_workstation' :
        command => $install_command,
        require => Archive['vmware_workstation'],
        creates => '/usr/bin/vmware',
      }
    }
    'absent' : {
      exec { 'uninstall_workstation' :
        command => $uninstall_command,
      }
    }
    default : {
      fail('Action unknown. VMware Workstation can be installed or absent')
    }
  }
}
