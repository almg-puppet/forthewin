class forthewin::libreoffice7::uninstall (
  String $help_pack_lang_name = 'English (United States)',
  Boolean $verbose = $forthewin::libreoffice7::verbose
) {
  warning("[${trusted[certname]}] In Uninstall class Installed LibreOffice version: ${facts[libreoffice_version]}")
  
  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] verbose = ${verbose}")
  }
  # Version of the package to be installed
  $v = split($forthewin::libreoffice7::version, '[.]')
  $full_version = $forthewin::libreoffice7::version
  $short_version = "${v[0]}.${v[1]}.${v[2]}"

  # Version of the package to be uninstalled
  $installed_version = split($facts[libreoffice_version], '[.]')

  if versioncmp($facts[libreoffice_version] , $full_version) > 0 { 

    warning("[${trusted[certname]}] Desinstalando LibreOffice: ${facts[libreoffice_version]}")

    package { "Desinstalando LibreOffice":
      name   => "LibreOffice ${installed_version[0]}.${installed_version[1]}.${installed_version[2]}.${installed_version[3]}",
      ensure => absent,
      before => Package["LibreOffice ${v[0]}.x"],
    }
  }
  
  $installed_help_version = split($facts[libreoffice_help_version], '[.]')
  $short_installed_help_version = "${installed_help_version[0]}.${installed_help_version[1]}"
  if versioncmp($facts[libreoffice_help_version] , $full_version) > 0 {
    
    warning("[${trusted[certname]}] Desinstalando LibreOffice Help Pack: ${facts[libreoffice_help_version]}")

    package { "Desinstalando LibreOffice Help Pack":
      name   => "LibreOffice ${short_installed_help_version} Help Pack (${help_pack_lang_name})",
      ensure => absent,
      before => Package["LibreOffice Help Pack"],
    }
  }

}
