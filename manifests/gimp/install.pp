# https://download.gimp.org/mirror/pub/gimp/
class forthewin::gimp::install {

  # Full path to installer
  if $forthewin::gimp::installer_filename {
    $installer = "${forthewin::gimp::installer_path}\\${forthewin::gimp::installer_filename}"
  } else {
    $installer = "${forthewin::gimp::installer_path}\\gimp-${forthewin::gimp::version}-setup.exe"
  }
  
  # Split version to get major, minor and revision number
  $v = split($forthewin::gimp::version, '[.]')

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] installer = ${installer}")
  info("[${trusted[certname]}] v         = ${v}")

  package { "GIMP ${v[0]}.${v[1]}.x":
    name            => "GIMP ${forthewin::gimp::version}",
    ensure          => $forthewin::gimp::version,
    source          => $installer,
    install_options => $forthewin::gimp::install_options,
  }

}