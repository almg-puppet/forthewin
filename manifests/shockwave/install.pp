class forthewin::shockwave::install {

  # Version parsing
  $v = split($forthewin::shockwave::version, '[.]')
  $major = "${v[0]}.${v[1]}"

  # Full path to installer
  $installer = "${forthewin::shockwave::installer_path}\\${forthewin::shockwave::installer_filename}"

  if $forthewin::shockwave::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] installer = ${installer}")
    info("[${trusted[certname]}] major     = ${major}")
    info("[${trusted[certname]}] v         = ${v}")
  }

  package { 'Adobe Shockwave Player':
    name            => "Adobe Shockwave Player ${major}",
		ensure          => $forthewin::shockwave::version,
		source          => $installer,
		install_options => $forthewin::shockwave::install_options,
	}

}