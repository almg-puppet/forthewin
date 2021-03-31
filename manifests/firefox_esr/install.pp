class forthewin::firefox_esr::install {

  # Assembles Package Name
  $arch = $forthewin::firefox_esr::path_arch ? {'win32' => 'x86', default => 'x64'}
  $version = delete($forthewin::firefox_esr::version, 'esr')
  $package_name = "Mozilla Firefox ${version} ESR (${arch} ${forthewin::firefox_esr::lang})"

  # Assembles Package Title
  $major = split($version, '[.]')[0]
  $package_title = "Mozilla Firefox ESR ${major}.x"

  # Full path to Firefox's installer
  if $forthewin::firefox_esr::installer_filename {
    $installer = "${forthewin::firefox_esr::installer_path}\\${forthewin::firefox_esr::installer_filename}"
  } else {
    # If not informed by parameter, the source path structure should mimics Mozilla's Firefox repository at
    # https://ftp.mozilla.org/pub/firefox/releases/
    $installer = "${forthewin::firefox_esr::installer_path}\\${forthewin::firefox_esr::version}\\${forthewin::firefox_esr::path_arch}\\${forthewin::firefox_esr::lang}\\Firefox Setup ${forthewin::firefox_esr::version}.msi"
  }

  # Map install options
  $install_options = [
    sprintf('DESKTOP_SHORTCUT=%s', $forthewin::firefox_esr::opt_desktop_shortcut),
    sprintf('INSTALL_MAINTENANCE_SERVICE=%s', $forthewin::firefox_esr::opt_install_maintenance_service),
    sprintf('START_MENU_SHORTCUT=%s', $forthewin::firefox_esr::opt_start_menu_shortcut),
    sprintf('TASKBAR_SHORTCUT=%s', $forthewin::firefox_esr::opt_taskbar_shortcut)
  ]

  if $forthewin::firefox_esr::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] arch            = ${arch}")
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

  # Uninstall Mozilla Maintenance Service, just in case
  unless $forthewin::firefox_esr::opt_install_maintenance_service {
    package { 'Mozilla Maintenance Service':
      ensure            => absent,
      require           => Package[$package_title],
      uninstall_options => ['/S'],
    }
  }

}