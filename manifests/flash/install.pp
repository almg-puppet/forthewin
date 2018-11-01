class forthewin::flash::install {

  # Version parsing
  $v = split($forthewin::flash::version, '[.]')
  $major = $v[0]
  $vfn = "${major}_${v[1]}r${v[2]}_${v[3]}"

  # Full path to each plugin installer
  # Name convention is the same of the archived version found in
  # https://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html#FlashPlayerarchives

  # Full path to ActiveX plugin installer
  if $forthewin::flash::installer_activex_filename {
    $installer_activex = "${forthewin::flash::installer_path}\\${forthewin::flash::installer_activex_filename}"
  } else {
    $installer_activex = "${forthewin::flash::installer_path}\\flashplayer${vfn}_winax.msi"
  }

  # Full path to NPAPI plugin installer
  if $forthewin::flash::installer_npapi_filename {
    $installer_npapi = "${forthewin::flash::installer_path}\\${forthewin::flash::installer_npapi_filename}"
  } else {
    $installer_npapi = "${forthewin::flash::installer_path}\\flashplayer${vfn}_win.msi"
  }

  # Full path to PPAPI plugin installer
  if $forthewin::flash::installer_ppapi_filename {
    $installer_ppapi = "${forthewin::flash::installer_path}\\${forthewin::flash::installer_ppapi_filename}"
  } else {
    $installer_ppapi = "${forthewin::flash::installer_path}\\flashplayer${vfn}_winpep.msi"
  }

  # Install/uninstall options of the resource package
  $install_options = ['/qn']
  $uninstall_options = ['/x']

  if $forthewin::flash::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] install_options   = ${install_options}")
    info("[${trusted[certname]}] installer_activex = ${installer_activex}")
    info("[${trusted[certname]}] installer_npapi   = ${installer_npapi}")
    info("[${trusted[certname]}] installer_ppapi   = ${installer_ppapi}")
    info("[${trusted[certname]}] major             = ${major}")
    info("[${trusted[certname]}] uninstall_options = ${uninstall_options}")
    info("[${trusted[certname]}] v                 = ${v}")
    info("[${trusted[certname]}] vfn               = ${vfn}")
  }

  # Flash for IE
  # Works for XP, Vista and W7
  # Windows 8 and 10 have it embedded as an app
  if $forthewin::flash::install_activex and $forthewin::params::platform in ['wxp', 'wvista', 'w7'] {
    package { 'Adobe Flash Player ActiveX':
      name => "Adobe Flash Player ${major} ActiveX",
      ensure => $forthewin::flash::version,
      source => $installer_activex,
      install_options => $install_options,
      uninstall_options => $uninstall_options,
    }
  }

  # Flash for Firefox
  if $forthewin::flash::install_npapi {
    package { 'Adobe Flash Player NPAPI':
      name => "Adobe Flash Player ${major} NPAPI",
      ensure => $forthewin::flash::version,
      source => $installer_npapi,
      install_options => $install_options,
      uninstall_options => $uninstall_options,
    }
  }

  # Flash for Opera and Chromium based browsers
  # NOTE: Chrome have it embedded
  if $forthewin::flash::install_ppapi and !$forthewin::params::platform in ['wxp', 'wvista'] {
    package { 'Adobe Flash Player PPAPI':
      name => "Adobe Flash Player ${major} PPAPI",
      ensure => $forthewin::flash::version,
      source => $installer_ppapi,
      install_options => $install_options,
      uninstall_options => $uninstall_options,
    }
  }

}