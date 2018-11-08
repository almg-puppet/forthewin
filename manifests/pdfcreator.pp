# Class: forthewin::pdfcreator
# ============================
#
# Installs PDF Creator: http://www.pdfforge.org/pdfcreator
#
# TODO
# ----
#
# * Breakdown command line options, translating them into easy to use parameters in this class:
# http://docs.pdfforge.org/pdfcreator/2.0/en/installing-pdfcreator/setup-command-line-parameters/
#
# * Convert this documentation into YARDS format in order to use puppet-strings: https://github.com/puppetlabs/puppet-strings
#
# Parameters
# ----------
#
# * `config_path`
# Path of the configuration file. Default value: \\winrepo.{domain}\pdfcreator. See: forthewin::params::repo_basepath and `load_inf` parameter.
# * `config_filename`
# Name of the configuration file optionally used by the installer. Default value: 'pdfcreator.inf'. See: `load_inf` parameter.
# Reference: http://docs.pdfforge.org/pdfcreator/2.0/en/installing-pdfcreator/setup-command-line-parameters/
# * `installer_filename`
# Installer's filename. Default value: uses the same pattern of the files downloaded from http://www.pdfforge.org/pdfcreator. ie, PDFCreator-${major_ver}_${minor_ver}_${revision}-Setup.exe
# * `installer_path`
# Installer's path. Default value: \\winrepo.{domain}\pdfcreator. See: forthewin::params::repo_basepath.
# * `load_inf`
# Should the installer use a configuration file? Default value: false.
# * `version`
# Mandatory. Version of the PDF Creator that will be installed. Default value: none. It should be set either explicitly, using resource-like declaration, or in Hiera.
#
# Examples
# --------
#
# @example
#    class { 'forthewin::pdfcreator':
#      version => '2.2.2',
#    }
#
# Authors
# -------
#
# ALMG Team
#
# Copyright
# ---------
#
# Copyright 2017 ALMG, unless otherwise noted.
#
class forthewin::pdfcreator (
  String $config_filename = 'pdfcreator.inf',
  String $config_path = "${forthewin::params::repo_basepath}\\pdfcreator",
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\pdfcreator",
  Boolean $load_inf = false,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  # Full path to PDF Creator's installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $v = split($version, '[.]')
    $installer = "${installer_path}\\PDFCreator-${v[0]}_${v[1]}_${v[2]}-Setup.exe"
  }

  # Install options
  $default_options = ['/VERYSILENT', '/NORESTART']
  if $load_inf {
    $install_options = concat($default_options, sprintf('/LOADINF="%s\\%s"', $config_path, $config_filename))
  } else {
    $install_options = $default_options
  }

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] config_filename    = ${config_filename}")
    info("[${trusted[certname]}] config_path        = ${config_path}")
    info("[${trusted[certname]}] installer_filename = ${installer_filename}")
    info("[${trusted[certname]}] installer_path     = ${installer_path}")
    info("[${trusted[certname]}] load_inf           = ${load_inf}")
    info("[${trusted[certname]}] version            = ${version}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] default_options    = ${default_options}")
    info("[${trusted[certname]}] install_options    = ${install_options}")
    info("[${trusted[certname]}] installer          = ${installer}")
    info("[${trusted[certname]}] v                  = ${v}")
  }

  package { 'PDF Creator':
    name            => 'PDFCreator',
    ensure          => $version,
    source          => $installer,
    install_options => $install_options,
  }

}