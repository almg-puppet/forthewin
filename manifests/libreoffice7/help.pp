class forthewin::libreoffice7::help (
  Optional[String] $help_pack_filename = undef,
  Array[String] $help_pack_install_options = [],
  String $help_pack_lang = 'en-US',
  String $help_pack_lang_name = 'English (United States)',
  Optional[String] $help_pack_path = undef,
  Boolean $verbose = $forthewin::libreoffice7::verbose
  ) {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] help_pack_filename        = ${help_pack_filename}")
    info("[${trusted[certname]}] help_pack_install_options = ${help_pack_install_options}")
    info("[${trusted[certname]}] help_pack_lang            = ${help_pack_lang}")
    info("[${trusted[certname]}] help_pack_lang_name       = ${help_pack_lang_name}")
    info("[${trusted[certname]}] help_pack_path            = ${help_pack_path}")
  }

  $v = split($forthewin::libreoffice7::version, '[.]')
  $full_version = $forthewin::libreoffice7::version
  $short_version = "${v[0]}.${v[1]}.${v[2]}"
  $shorter_version = "${v[0]}.${v[1]}"

  # Installer's path only
  if $help_pack_path {
    $installer_path = $help_pack_path
  } else {
    $installer_path = $forthewin::libreoffice7::install::installer_path
  }

  # Installer's full path - x86 and x64
  if $help_pack_filename {
    $installer_x86 = "${installer_path}\\${help_pack_filename}"
    $installer_x64 = "${installer_path}\\${help_pack_filename}"
  } else {
    # Name convention is the same of https://www.libreoffice.org/download/download/
    $installer_x86 = "${installer_path}\\LibreOffice_${short_version}_Win_x86_helppack_${help_pack_lang}.msi"
    $installer_x64 = "${installer_path}\\LibreOffice_${short_version}_Win_x64_helppack_${help_pack_lang}.msi"
  }

  # Choose which installer to use
  if $forthewin::libreoffice7::install::install_x86_only {
    $installer = $installer_x86
  } else {
    if $facts[architecture] == 'x86' {
      $installer = $installer_x86
    } else {
      $installer = $installer_x64
    }
  }

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] v               = ${v}")
    info("[${trusted[certname]}] full_version    = ${full_version}")
    info("[${trusted[certname]}] short_version   = ${short_version}")
    info("[${trusted[certname]}] shorter_version = ${shorter_version}")
    info("[${trusted[certname]}] installer_x86   = ${installer_x86}")
    info("[${trusted[certname]}] installer_x64   = ${installer_x64}")
    info("[${trusted[certname]}] installer       = ${installer}")
  }

  package { 'LibreOffice Help Pack':
    name            => "LibreOffice ${shorter_version} Help Pack (${help_pack_lang_name})",
    ensure          => $full_version,
    source          => $installer,
    install_options => $help_pack_install_options,
  }

}