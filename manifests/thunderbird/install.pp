class forthewin::thunderbird::install {

  $arch = $forthewin::thunderbird::os ? {'win32' => 'x86', default => 'x64'}
  $major = split($forthewin::thunderbird::version, '[.]')[0]
  $package_name = "Mozilla Thunderbird ${forthewin::thunderbird::version} (${arch} ${forthewin::thunderbird::lang})"
  $package_title = "Mozilla Thunderbird ${major}.x"

  if empty($forthewin::thunderbird::installer_args) {
    $install_options = ['-ms']
  } else {
    $install_options = ["/INI=${forthewin::thunderbird::config_ini}"]
  }

  # Full path to Thunderbird's installer
  if $forthewin::thunderbird::installer_filename {
    $installer = "${forthewin::thunderbird::installer_path}/${forthewin::thunderbird::installer_filename}"
  } else {
    # If not informed by parameter, the source path structure should mimics Mozilla's Thunderbird repository at
    # https://ftp.mozilla.org/pub/thunderbird/releases/
    $installer = "${forthewin::thunderbird::installer_path}/${forthewin::thunderbird::version}/${forthewin::thunderbird::os}/${forthewin::thunderbird::lang}/Thunderbird Setup ${forthewin::thunderbird::version}.exe"
  }

  # https://docs.puppet.com/puppet/latest/resources_package_windows.html
  package { $package_title:
    name            => $package_name,
    ensure          => $forthewin::thunderbird::version,
    source          => $installer,
    install_options => $install_options,
  }

  if $forthewin::thunderbird::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] arch            = ${arch}")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer       = ${installer}")
    info("[${trusted[certname]}] major           = ${major}")
    info("[${trusted[certname]}] package_name    = ${package_name}")
    info("[${trusted[certname]}] package_title   = ${package_title}")
  }

}