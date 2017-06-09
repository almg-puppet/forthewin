# https://download.gimp.org/mirror/pub/gimp/
class forthewin::gimp (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\gimp",
  Pattern[/\A[a-z]{2,3}(?:-[A-Z]{2})?\Z/] $lang = 'en-US',
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("installer_filename = ${installer_filename}")
  info("installer_path = ${installer_path}")
  info("lang = ${lang}")
  info("version = ${version}")

  # Split version to get major, minor and revision number
  $v = split($version, '[.]')

  # Full path to installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\gimp-${version}-setup.exe"
  }

  # Install options of the resource package
  $install_options = ["/LANG=${lang}", "/verysilent", "/norestart"]

  info('VARIABLES:')
  info("v = ${v}")
  info("installer = ${installer}")
  info("install_options = ${install_options}")

	package { "GIMP ${v[0]}.${v[1]}.x":
		name => "GIMP ${version}",
		ensure => $version,
		source => $installer,
		install_options => $install_options,
	}

}