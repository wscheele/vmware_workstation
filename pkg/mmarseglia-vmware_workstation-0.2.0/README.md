# vmware_workstation
[![Build Status](https://travis-ci.org/mmarseglia/vmware_workstation.svg)](https://travis-ci.org/mmarseglia/vmware_workstation)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with vmware_workstation](#setup)
    * [What vmware_workstation affects](#what-vmware_workstation-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vmware_workstation](#beginning-with-vmware_workstation)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Installs VMware Workstation on Linux.

## Module Description

Install and configure VMware Workstation installation on Linux. By default
will install VMware Workstation without license key, 30-day trial.

## Setup

### What vmware_workstation affects

* Installs VMware Workstation binaries.
* Cannot be installed along side any VMware products except vSphere Client, vCenter Converter Standalone.

### Beginning with vmware_workstation

Install with defaults:

include vmware_workstation

Remove VMware Workstation

class { 'vmware_workstation' :
	ensure	=> absent,
}

## Usage

You can control how VMware Workstation is installed.

 [*ensure*]
 Must be 'installed' or 'absent'.

 [*serial_number*]
 Optional. Set the serial number for VMware Workstation. If this is left
 blank then VMware Workstation will expire after 30 days. A warning
 is issued during installation.

 [*url*]
 Optional. URL to download VMware workstation from.
 Defaults to https://download3.vmware.com/software/wkst/file/

 [*version*]
 Optional. Version of VMware Workstation to download.
 Default 11.1.0-2496824

 [*cache_dir*]
 Optional. Wget will keep a cached copy of the installer on the server and
 only re-download if the date/time stamp of the source changes.
 Default /var/cache/wget

 [*destination*]
 Optional. Save location for wget to save installer to.
 Default /tmp/

 [*filename*]
 Optional. Name of the VMware Workstation installer to download.
 Default VMware-Workstation-Full-${version}.${::architecture}.bundle or
 VMware-workstation-full-${version}.exe

 [*install_options*]
 Optional. Installation options for VMware Workstation. See VMware
 documentation.
 Default silent install, accept EULA, ignore errors. Reference

This module uses two facts to ensure VMware Workstation can be installed.

$architecture is checked to ensure the node is 64-bit.  VMware Workstation can only
be installed on a 64-bit OS.

$memorytotal_mb is checked to ensure total node memory is greater than 2GB. VMware
Workstation requires at least 2GB total memory.

https://github.com/maestrodev/puppet-wget module is used to fetch the VMware
Workstation installer from the default URL.

An exec calls the VMware workstation installer with the default installation
options.  If you choose to override the default options you must specify
ALL installation options, including Accept EULA, silent install, etc.

## Limitations

Tested on CentOS6.5.

Some code written to accomodate Windows but it is incomplete and not tested.

## Development

Fork and send a pull request or submit an issue via Github to contribute.

## Release Notes/Contributors/Etc 

