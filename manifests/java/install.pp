class forthewin::java::install {

  # Java version, as displayed on the "Programs and Resources" section of the Control Panel.
  # ${version}.0.${update}0.${build}
  $v = split($forthewin::java::version, '[.]')
  $version = $v[0]
  $update = regsubst($v[2], '([0-9]+)0', '\1')

  # Full path to installer
  # Notice that we use the .msi package and not the .exe installer.
  if $forthewin::java::installer_x86_filename {
    $installer_x86 = "${forthewin::java::installer_path}\\${forthewin::java::installer_x86_filename}"
  } else {
    # Name convention is the same of https://www.java.com/pt_BR/download/manual.jsp
    $installer_x86 = "${forthewin::java::installer_path}\\jre-${version}u${update}-windows-i586.msi"
  }
  if $forthewin::java::installer_x64_filename {
    $installer_x64 = "${forthewin::java::installer_path}\\${forthewin::java::installer_x64_filename}"
  } else {
    # Name convention is the same of https://www.java.com/pt_BR/download/manual.jsp
    $installer_x64 = "${forthewin::java::installer_path}\\jre-${version}u${update}-windows-x64.msi"
  }

  if $forthewin::java::disable_autoupdate {
    $install_options = concat($forthewin::java::default_options, ['AUTO_UPDATE=Disable'])
  } else {
    $install_options = $forthewin::java::default_options
  }

  if $forthewin::java::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer_x86   = ${installer_x86}")
    info("[${trusted[certname]}] installer_x64   = ${installer_x64}")
    info("[${trusted[certname]}] update          = ${update}")
    info("[${trusted[certname]}] v               = ${v}")
    info("[${trusted[certname]}] version         = ${version}")
  }

  # Installs Java 32-bit if Windows x86 or install_x86_on_x64 parameter is set to true
  if $facts[architecture] == 'x86' or $forthewin::java::install_x86_on_x64 {
    package { 'Java 32-bit':
      name            => "Java ${version} Update ${update}",
      ensure          => $forthewin::java::version,
      source          => $installer_x86,
      install_options => $install_options,
    }
  }

  # Installs Java 64-bit if Windows x64
  if $facts[architecture] == 'x64' {
    package { 'Java 64-bit':
      name            => "Java ${version} Update ${update} (64-bit)",
      ensure          => $forthewin::java::version,
      source          => $installer_x64,
      install_options => $install_options,
    }
  }
}

