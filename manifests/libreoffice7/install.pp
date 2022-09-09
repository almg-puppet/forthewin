# https://wiki.documentfoundation.org/Deployment_and_Migration
class forthewin::libreoffice7::install (
  Boolean $allusers = true,
  Boolean $check_for_updates = false,
  Boolean $create_desktop_link = true,
  Boolean $install_x86_only = false,
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\libreoffice",
  Array[String] $msi_options = [],
  Boolean $register_all_mso_types = false,
  Boolean $vc_redist = true,
  Boolean $verbose = $forthewin::libreoffice7::verbose
  ) {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] allusers               = ${allusers}")
    info("[${trusted[certname]}] check_for_updates      = ${check_for_updates}")
    info("[${trusted[certname]}] create_desktop_link    = ${create_desktop_link}")
    info("[${trusted[certname]}] install_x86_only       = ${install_x86_only}")
    info("[${trusted[certname]}] installer_filename     = ${installer_filename}")
    info("[${trusted[certname]}] installer_path         = ${installer_path}")
    info("[${trusted[certname]}] msi_options            = ${msi_options}")
    info("[${trusted[certname]}] register_all_mso_types = ${register_all_mso_types}")
    info("[${trusted[certname]}] vc_redist              = ${vc_redist}")
  }

  $v = split($forthewin::libreoffice7::version, '[.]')
  $full_version = $forthewin::libreoffice7::version
  $short_version = "${v[0]}.${v[1]}.${v[2]}"

  # Installer's full path - x86 and x64
  if $installer_filename {
    $installer_x86 = "${installer_path}\\${installer_filename}"
    $installer_x64 = "${installer_path}\\${installer_filename}"
  } else {
    # Name convention is the same of https://www.libreoffice.org/download/download/
    $installer_x86 = "${installer_path}\\LibreOffice_${short_version}_Win_x86.msi"
    $installer_x64 = "${installer_path}\\LibreOffice_${short_version}_Win_x64.msi"
  }

  # Choose which installer to use
  if $install_x86_only {
    $installer = $installer_x86
  } else {
    if $facts[architecture] == 'x86' {
      $installer = $installer_x86
    } else {
      $installer = $installer_x64
    }
  }

  $parameterized_options = [
    sprintf('ALLUSERS=%d', $allusers ? { true => 1, false => 0 }),
    sprintf('CREATEDESKTOPLINK=%d', $create_desktop_link ? { true => 1, false => 0 }),
    sprintf('ISCHECKFORPRODUCTUPDATES=%d', $check_for_updates ? { true => 1, false => 0 }),
    sprintf('REGISTER_ALL_MSO_TYPES=%d', $register_all_mso_types ? { true => 1, false => 0 }),
    sprintf('VC_REDIST=%d', $vc_redist ? { true => 1, false => 0 })
  ]
  $install_options = concat($msi_options, $parameterized_options)

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] full_version           = ${full_version}")
    info("[${trusted[certname]}] install_options        = ${install_options}")
    info("[${trusted[certname]}] installer              = ${installer}")
    info("[${trusted[certname]}] installer_x86          = ${installer_x86}")
    info("[${trusted[certname]}] installer_x64          = ${installer_x64}")
    info("[${trusted[certname]}] parameterized_options  = ${parameterized_options}")
    info("[${trusted[certname]}] short_version          = ${short_version}")
    info("[${trusted[certname]}] v                      = ${v}")
  }

  package { "LibreOffice ${v[0]}.x":
    name            => "LibreOffice ${full_version}",
    ensure          => $full_version,
    source          => $installer,
    install_options => $install_options,
  }

}