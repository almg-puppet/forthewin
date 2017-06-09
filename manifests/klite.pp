class forthewin::klite (
  String $config_filename = 'klcp_mega_unattended.ini',
  Optional[String] $config_path = undef,
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\klite",
  Boolean $unattended_installation = true,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("config_filename = ${config_filename}")
  info("config_path = ${config_path}")
  info("installer_filename = ${installer_filename}")
  info("installer_path = ${installer_path}")
  info("unattended_installation = ${unattended_installation}")
  info("version = ${version}")

  # Full path to installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\K-Lite_Codec_Pack_${version}_Mega.exe"
  }

  # Full path to config file
  if $config_path {
    $unattended_file = "${config_path}\\${config_filename}"
  } else {
    $unattended_file = "${installer_path}\\${config_filename}"
  }

  # Install options of the resource package
  $default_install_options = ["/VERYSILENT", "/NORESTART", "/SUPPRESSMSGBOXES", "/FORCEUPGRADE"]
  if $unattended_installation {
    $install_options = concat($default_install_options, ["/LoadInf=\"${unattended_file}\""])
  } else {
    $install_options = $default_install_options
  }

  info('VARIABLES:')
  info("installer = ${installer}")
  info("unattended_file = ${unattended_file}")
  info("install_options = ${install_options}")

  unless $forthewin::params::platform == 'wxp' {
    package { 'K-Lite Mega Codec Pack':
      name            => "K-Lite Mega Codec Pack ${version}",
      ensure          => $version,
      source          => $installer,
      install_options => $install_options,
    }
  }

}