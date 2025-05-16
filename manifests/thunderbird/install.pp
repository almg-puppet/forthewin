class forthewin::thunderbird::install {

  # Assembles Package Name
  $arch = $forthewin::thunderbird::path_arch ? {'win32' => 'x86', default => 'x64'}
  $version = delete($forthewin::thunderbird::version, 'esr')
  if versioncmp($version, '78.12.0') >= 0 {
    $package_name = "Mozilla Thunderbird (${arch} ${forthewin::thunderbird::lang})"
  } else {
    $package_name = "Mozilla Thunderbird ${version} (${arch} ${forthewin::thunderbird::lang})"
  }

  # Assembles Package Title
  $major = split($version, '[.]')[0]
  $package_title = "Mozilla Thunderbird ${major}.x"

  # Full path to Thunderbird's installer
  if $forthewin::thunderbird::installer_filename {
    $installer = "${forthewin::thunderbird::installer_path}\\${forthewin::thunderbird::installer_filename}"
  } else {
    # If not informed by parameter, the source path structure should mimics Mozilla's Thunderbird repository at
    # https://ftp.mozilla.org/pub/thunderbird/releases/
    $installer = "${forthewin::thunderbird::installer_path}\\${forthewin::thunderbird::version}\\${forthewin::thunderbird::path_arch}\\${forthewin::thunderbird::lang}\\Thunderbird Setup ${forthewin::thunderbird::version}.msi"
  }

  # Map install options
  # https://enterprise.thunderbird.net/deploy/deploy-thunderbird-with-msi-installers
  $bol_options = [
    sprintf('DESKTOP_SHORTCUT=%s', $forthewin::thunderbird::opt_desktop_shortcut),
    sprintf('INSTALL_MAINTENANCE_SERVICE=%s', $forthewin::thunderbird::opt_install_maintenance_service),
    sprintf('START_MENU_SHORTCUT=%s', $forthewin::thunderbird::opt_start_menu_shortcut),
    sprintf('TASKBAR_SHORTCUT=%s', $forthewin::thunderbird::opt_taskbar_shortcut)
  ]
  $install_options = $bol_options + ($forthewin::thunderbird::opt_install_dirname ? { undef => [], default => sprintf('INSTALL_DIRECTORY_NAME=%s', $forthewin::thunderbird::opt_install_dirname)}) + ($forthewin::thunderbird::opt_install_dirpath ? {undef => [], default => sprintf('INSTALL_DIRECTORY_PATH=%s', $forthewin::thunderbird::opt_install_dirpath)})

  if $forthewin::thunderbird::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] arch            = ${arch}")
    info("[${trusted[certname]}] bol_options     = ${bol_options}")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer       = ${installer}")
    info("[${trusted[certname]}] major           = ${major}")
    info("[${trusted[certname]}] package_name    = ${package_name}")
    info("[${trusted[certname]}] package_title   = ${package_title}")
    info("[${trusted[certname]}] version         = ${version}")
  }

  package { $package_title:
    name            => $package_name,
    ensure          => $version,
    source          => $installer,
    install_options => $install_options,
  }

}