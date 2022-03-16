class forthewin::thunderbird_legacy::install {

  $arch = $forthewin::thunderbird_legacy::os ? {'win32' => 'x86', default => 'x64'}
  $major = split($forthewin::thunderbird_legacy::version, '[.]')[0]
  $package_name = "Mozilla Thunderbird ${forthewin::thunderbird_legacy::version} (${arch} ${forthewin::thunderbird_legacy::lang})"
  $package_title = "Mozilla Thunderbird ${major}.x"

  if empty($forthewin::thunderbird_legacy::installer_args) {
    $install_options = ['-ms']
  } else {
    $install_options = ["/INI=${forthewin::thunderbird_legacy::config_ini}"]
  }

  # Full path to Thunderbird's installer
  if $forthewin::thunderbird_legacy::installer_filename {
    $installer = "${forthewin::thunderbird_legacy::installer_path}/${forthewin::thunderbird_legacy::installer_filename}"
  } else {
    # If not informed by parameter, the source path structure should mimics Mozilla's Thunderbird repository at
    # https://ftp.mozilla.org/pub/thunderbird/releases/
    $installer = "${forthewin::thunderbird_legacy::installer_path}/${forthewin::thunderbird_legacy::version}/${forthewin::thunderbird_legacy::os}/${forthewin::thunderbird_legacy::lang}/Thunderbird Setup ${forthewin::thunderbird_legacy::version}.exe"
  }

  # https://docs.puppet.com/puppet/latest/resources_package_windows.html
  package { $package_title:
    name            => $package_name,
    ensure          => $forthewin::thunderbird_legacy::version,
    source          => $installer,
    install_options => $install_options,
  }

  if $forthewin::thunderbird_legacy::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] arch            = ${arch}")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer       = ${installer}")
    info("[${trusted[certname]}] major           = ${major}")
    info("[${trusted[certname]}] package_name    = ${package_name}")
    info("[${trusted[certname]}] package_title   = ${package_title}")
  }

}