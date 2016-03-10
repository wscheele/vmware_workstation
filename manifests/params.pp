# == Class vmware_workstation::params
# Default parameters for vmware_workstation
#
# === Variables
#
# [*source*]
# Full URI to source file to download.
#
# [*install_command*]
# Fully qualified installation command used to install VMware Workstation.
# According to https://www.vmware.com/support/pubs/ws_pubs.html
#
# [*uninstall_command*]
# Fully qualified uninstallation command used to uninstall VMware Workstation.
# According to https://www.vmware.com/support/pubs/ws_pubs.html
#
# === TODO
# Windows section needs uninstall command, additional installation options.
#
class vmware_workstation::params {

  $url = 'https://download3.vmware.com/software/wkst/file/'
  $version = '12.1.0-3272444'

  if $::kernel in 'Linux' {
    $cache_dir = '/var/cache/wget'
    $destination = '/tmp/'
    $filename = "VMware-Workstation-Full-${version}.x86_64.bundle"
    $install_options = '--ignore-errors --console --required --eulas-agreed'
    $install_command = "/bin/sh ${destination}${filename} ${install_options}"
    $uninstall_command = '/usr/lib/vmware-installer -u vmware-workstation'
  } elsif $::kernel in 'Windows' {
    $cache_dir = 'C:\Windows\Temp\\'
    $destination  = 'C:\TEMP\\'
    $filename = "VMware-workstation-full-${version}.exe"
    $install_command = "${destination}${filename} ${install_options}"
    $install_options = '/s /nsr /v "EULAS_AGREED=1"'
  }

  if $::vmware_workstation::serial_number == undef {
    notice('No serial number specified. VMware Workstation will expire after 30 days')
  } else {
    $install_options="${install_options} --set-setting vmware-workstation ${::vmware_workstation::serial_number}"
  }

}
