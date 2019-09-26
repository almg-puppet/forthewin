# Class: forthewin::cdburnerxp
# ============================
#
# Installs PDF Creator: http://www.pdfforge.org/pdfcreator
#
# TODO
# ----
#
#
# * Convert this documentation into YARDS format in order to use puppet-strings: https://github.com/puppetlabs/puppet-strings
#
# Parameters
# ----------
#
# * `installer_filename`
# Installer's filename. Default value: uses the same pattern of the files downloaded from https://cdburnerxp.se/en/download ie, cdbxp_setup_${major_ver}.${minor_ver}.${revision}.${build}.exe
# * `installer_path`
# Installer's path. Default value: \\winrepo.{domain}\pdfcreator. See: forthewin::params::repo_basepath.
# * `version`
# Mandatory. Version of the PDF Creator that will be installed. Default value: none. It should be set either explicitly, using resource-like declaration, or in Hiera.
#
# Examples
# --------
#
# @example
#    class { 'forthewin::cdburnerxp':
#      version => '2.2.2.1234',
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
class forthewin::cdburnerxp (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\cdburnerxp",
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  # Full path to CD BurnerXP's installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $v = split($version, '[.]')
    $installer = "${installer_path}\\cdbxp_setup_${v[0]}.${v[1]}.${v[2]}.${v[3]}.exe"
  }

  # Install options
  $install_options = ['/VERYSILENT', '/NORESTART']


  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] installer_filename = ${installer_filename}")
    info("[${trusted[certname]}] installer_path     = ${installer_path}")
    info("[${trusted[certname]}] version            = ${version}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] install_options    = ${install_options}")
    info("[${trusted[certname]}] installer          = ${installer}")
    info("[${trusted[certname]}] v                  = ${v}")
  }

  package { 'CD Burner XP':
    name            => 'CDBurnerXP',
    ensure          => $version,
    source          => $installer,
    install_options => $install_options,
  }

}