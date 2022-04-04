# https://wiki.documentfoundation.org/Deployment_and_Migration
class forthewin::libreoffice::install {

  $v = split($forthewin::libreoffice::version, '[.]')
  $full_version = $forthewin::libreoffice::version
  $short_version = "${v[0]}.${v[1]}.${v[2]}"

  # Installer's full path - x86 and x64
  if $forthewin::libreoffice::installer_filename {
    $installer_x86 = "${forthewin::libreoffice::installer_path}\\${forthewin::libreoffice::installer_filename}"
    $installer_x64 = "${forthewin::libreoffice::installer_path}\\${forthewin::libreoffice::installer_filename}"
  } else {
    # Name convention is the same of https://www.libreoffice.org/download/download/
    $installer_x86 = "${forthewin::libreoffice::installer_path}\\LibreOffice_${short_version}_Win_x86.msi"
    $installer_x64 = "${forthewin::libreoffice::installer_path}\\LibreOffice_${short_version}_Win_x64.msi"
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

  $parameterized_options = [
    sprintf('CREATEDESKTOPLINK=%d', $forthewin::libreoffice::create_desktop_link ? { true => 1, false => 0 }),
    sprintf('RebootYesNo=%s', $forthewin::libreoffice::reboot_after_install ? { true => 'Yes', false => 'No' }),
    sprintf('ISCHECKFORPRODUCTUPDATES=%d', $forthewin::libreoffice::check_for_updates ? { true => 1, false => 0 }),
    sprintf('REGISTER_ALL_MSO_TYPES=%d', $forthewin::libreoffice::register_mso_types ? { true => 1, false => 0 }),
    sprintf('REGISTER_NO_MSO_TYPES=%d', $forthewin::libreoffice::register_mso_types ? { true => 0, false => 1 }),
    sprintf('QUICKSTART=%d', $forthewin::libreoffice::enable_quickstart ? { true => 1, false => 0 }),
    sprintf('UI_LANGS=%s', join($forthewin::libreoffice::ui_langs, ',')),
    sprintf('REMOVE=%s%s', $forthewin::libreoffice::remove_online_update ? {true => $forthewin::libreoffice::remove_features ? {[] => 'gm_o_Onlineupdate', default => 'gm_o_Onlineupdate,'}, false => ''}, $forthewin::libreoffice::remove_features ? {[] => '', default => join($forthewin::libreoffice::remove_features, ',')})
  ]
  $install_options = delete(concat($forthewin::libreoffice::install_options, $parameterized_options), 'REMOVE=')

  if $forthewin::libreoffice::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] v                     = ${v}")
    info("[${trusted[certname]}] full_version          = ${full_version}")
    info("[${trusted[certname]}] short_version         = ${short_version}")
    info("[${trusted[certname]}] parameterized_options = ${parameterized_options}")
    info("[${trusted[certname]}] install_options       = ${install_options}")
    info("[${trusted[certname]}] installer_x86         = ${installer_x86}")
    info("[${trusted[certname]}] installer_x64         = ${installer_x64}")
    info("[${trusted[certname]}] installer             = ${installer}")
  }

  package { "LibreOffice ${v[0]}.x":
    name            => "LibreOffice ${full_version}",
    ensure          => $full_version,
    source          => $installer,
    install_options => $install_options,
  }

}