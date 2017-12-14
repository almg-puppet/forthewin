class forthewin::libreoffice::help {

  $v = split($forthewin::libreoffice::version, '[.]')
  $full_version = $forthewin::libreoffice::version
  $short_version = "${v[0]}.${v[1]}.${v[2]}"
  $shorter_version = "${v[0]}.${v[1]}"

  # Installer's path only
  if $forthewin::libreoffice::help_pack_path {
    $installer_path = $forthewin::libreoffice::help_pack_path
  } else {
    $installer_path = $forthewin::libreoffice::installer_path
  }

  # Installer's full path - x86 and x64
  if $forthewin::libreoffice::help_pack_filename {
    $installer_x86 = "${installer_path}\\${forthewin::libreoffice::help_pack_filename}"
    $installer_x64 = "${installer_path}\\${forthewin::libreoffice::help_pack_filename}"
  } else {
    # Name convention is the same of https://www.libreoffice.org/download/download/
    $installer_x86 = "${installer_path}\\LibreOffice_${short_version}_Win_x86_helppack_${forthewin::libreoffice::help_pack_lang}.msi"
    $installer_x64 = "${installer_path}\\LibreOffice_${short_version}_Win_x64_helppack_${forthewin::libreoffice::help_pack_lang}.msi"
  }

  # Choose which installer to use
  if $forthewin::libreoffice::install_x86_only {
    $installer = $installer_x86
  } else {
    if $facts[architecture] == 'x86' {
      $installer = $installer_x86
    } else {
      $installer = $installer_x64
    }
  }

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] v               = ${v}")
  info("[${trusted[certname]}] full_version    = ${full_version}")
  info("[${trusted[certname]}] short_version   = ${short_version}")
  info("[${trusted[certname]}] shorter_version = ${shorter_version}")
  info("[${trusted[certname]}] installer_x86   = ${installer_x86}")
  info("[${trusted[certname]}] installer_x64   = ${installer_x64}")
  info("[${trusted[certname]}] installer       = ${installer}")

  package { 'LibreOffice Help Pack':
    name            => "LibreOffice ${shorter_version} Help Pack (${forthewin::libreoffice::help_pack_lang_name})",
    ensure          => $full_version,
    source          => $installer,
    install_options => $forthewin::libreoffice::help_pack_install_options,
  }

}