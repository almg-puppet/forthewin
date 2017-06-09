class forthewin::shockwave::preinstall {

  $command = "${forthewin::params::tempdir}\\shockwaveUninstallMSI.ps1"
  $onlyif = "${forthewin::params::tempdir}\\shockwaveCheckMSI.ps1"

  info('VARIABLES:')
  info("command = ${command}")
  info("onlyif = ${onlyif}")

  file { $onlyif:
    ensure => file,
    source => 'puppet:///modules/forthewin/shockwave/shockwaveCheckMSI.ps1',
    before => Exec['uninstall_msi_before_installing_exe'],
  }

  file { $command:
    ensure => file,
    source => 'puppet:///modules/forthewin/shockwave/shockwaveUninstallMSI.ps1',
    before => Exec['uninstall_msi_before_installing_exe'],
  }

  exec { 'uninstall_msi_before_installing_exe':
    command => "${forthewin::params::powershell} ${command}",
    onlyif  => "${forthewin::params::powershell} ${onlyif}",
  }

}