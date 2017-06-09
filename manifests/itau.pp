class forthewin::itau (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\itau",
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("installer_filename = ${installer_filename}")
  info("installer_path     = ${installer_path}")
  info("version            = ${version}")

  # Full path to installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\aplicativoitau-${version}.msi"
  }

  # Install options of the resource package
  $install_options = ["/qn"]

  info('VARIABLES:')
  info("installer       = ${installer}")
  info("install_options = ${install_options}")

  unless $forthewin::params::platform == 'wxp' {
    package { 'Aplicativo Itau':
      name            => "Aplicativo Ita\u00FA",
      ensure          => $version,
      source          => $installer,
      install_options => $install_options,
    }
  }
}