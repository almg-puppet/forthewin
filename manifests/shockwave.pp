# https://get.adobe.com/br/shockwave/otherversions/
# http://www.adobe.com/products/shockwaveplayer/distribution3.html
# Shockwave is distributed either in EXE or MSI. A MSI does not update EXE and vice versa. Also, install/uninstall options are not interchangeable.
# We strongly advise that you stick to one of them. Otherwise you may end up with multiple versions installed.
# If you want to migrate from MSI only to EXE only, use "uninstall_msi = true" to wipe out any MSI before installing EXE.
class forthewin::shockwave (
  String $installer_filename = 'sw_lic_full_installer.exe',
  String $installer_path = "${forthewin::params::repo_basepath}\\adobe",
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  Boolean $uninstall_msi = false,
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("installer_filename = ${installer_filename}")
  info("installer_path = ${installer_path}")
  info("version = ${version}")
  info("uninstall_msi = ${uninstall_msi}")

  # Install options of the installer
  case $installer_filename {
    /[.]msi$/: { $install_options = ['/qn'] }
    /[.]exe$/: { $install_options = ['/S'] }
    default: { fail('Installer must be either MSI or EXE.') }
  }

  info('VARIABLES:')
  info("install_options = ${install_options}")

  contain forthewin::shockwave::install

  if $uninstall_msi and $forthewin::params::platform != 'wxp' {
    # Remove unwanted software
    contain forthewin::shockwave::preinstall
    Class['forthewin::shockwave::preinstall'] -> Class['forthewin::shockwave::install']
  }

}