# https://get.adobe.com/br/shockwave/otherversions/
# http://www.adobe.com/products/shockwaveplayer/distribution3.html
# Shockwave is distributed either in EXE or MSI. A MSI does not update EXE and vice versa. Also, install/uninstall options are not interchangeable.
# We strongly advise that you stick to one of them. Otherwise you may end up with multiple versions installed.
# If you want to migrate from MSI only to EXE only, use "uninstall_msi = true" to wipe out any MSI before installing EXE.
class forthewin::shockwave (
  String $installer_filename = 'sw_lic_full_installer.exe',
  String $installer_path = "${forthewin::params::repo_basepath}\\adobe",
  Boolean $uninstall_msi = false,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] installer_filename = ${installer_filename}")
    info("[${trusted[certname]}] installer_path     = ${installer_path}")
    info("[${trusted[certname]}] uninstall_msi      = ${uninstall_msi}")
    info("[${trusted[certname]}] version            = ${version}")
  }

  # Install options of the installer
  case $installer_filename {
    /[.]msi$/: { $install_options = ['/qn'] }
    /[.]exe$/: { $install_options = ['/S'] }
    default: { fail('Installer must be either MSI or EXE.') }
  }

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] install_options = ${install_options}")
  }

  contain forthewin::shockwave::install

  if $uninstall_msi and $forthewin::params::platform != 'wxp' {
    # Remove unwanted software
    contain forthewin::shockwave::preinstall
    Class['forthewin::shockwave::preinstall'] -> Class['forthewin::shockwave::install']
  }

}