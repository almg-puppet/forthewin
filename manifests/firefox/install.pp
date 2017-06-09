class forthewin::firefox::install {

  if $forthewin::firefox::version =~ /esr/ {
    $esr = 'ESR '
    $version = delete($forthewin::firefox::version, 'esr')
  } else {
    $esr = ''
    $version = $forthewin::firefox::version
  }

  $arch = $forthewin::firefox::os ? {'win32' => 'x86', default => 'x64'}
  $major = split($version, '[.]')[0]
  $package_name = "Mozilla Firefox ${version} ${esr}(${arch} ${forthewin::firefox::lang})"
  $package_title = "Mozilla Firefox ${esr}${major}.x"

  # Full path to Firefox's installer
  if $forthewin::firefox::installer_filename {
    $installer = "${forthewin::firefox::installer_path}/${forthewin::firefox::installer_filename}"
  } else {
    # If not informed by parameter, the source path structure should mimics Mozilla's Firefox repository at
    # https://ftp.mozilla.org/pub/firefox/releases/
    $installer = "${forthewin::firefox::installer_path}/${forthewin::firefox::version}/${forthewin::firefox::os}/${forthewin::firefox::lang}/Firefox Setup ${forthewin::firefox::version}.exe"
  }

  if empty($forthewin::firefox::installer_args) {
    $install_options = ['-ms']
  } else {
    $install_options = ["/INI=${forthewin::firefox::config_ini}"]
  }

  package { $package_title:
    name            => $package_name,
    ensure          => $version,
    source          => $installer,
    install_options => $install_options,
  }

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] arch            = ${arch}")
  info("[${trusted[certname]}] esr             = ${esr}")
  info("[${trusted[certname]}] install_options = ${install_options}")
  info("[${trusted[certname]}] installer       = ${installer}")
  info("[${trusted[certname]}] major           = ${major}")
  info("[${trusted[certname]}] package_name    = ${package_name}")
  info("[${trusted[certname]}] package_title   = ${package_title}")
  info("[${trusted[certname]}] version         = ${version}")

}