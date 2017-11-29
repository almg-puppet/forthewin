class forthewin::sevenzip::install {

  # Install options of the resource package
  $install_options = ["/qn"]

  # Version without dots "."
  $v = regsubst($forthewin::sevenzip::version, '[.]', '', 'G')

  # x86 and x64 patterns of the installer filename
  $installer_x86 = "${forthewin::sevenzip::installer_path}\\7z${v}.msi"
  $installer_x64 = "${forthewin::sevenzip::installer_path}\\7z${v}-x64.msi"

  # x86 and x64 patterns for the package name
  $package_x86 = "7-Zip ${forthewin::sevenzip::version}"
  $package_x64 = "7-Zip ${forthewin::sevenzip::version} (x64 edition)"

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] install_options = ${install_options}")
  info("[${trusted[certname]}] installer_x86   = ${installer_x86}")
  info("[${trusted[certname]}] installer_x64   = ${installer_x64}")
  info("[${trusted[certname]}] package_x86     = ${package_x86}")
  info("[${trusted[certname]}] package_x64     = ${package_x64}")
  info("[${trusted[certname]}] v               = ${v}")

  # Full path to installer
  if $forthewin::sevenzip::installer_filename {

    $installer = "${installer_path}\\${installer_filename}"

    if $forthewin::sevenzip::installer_arch == 'x86' {
      $package = $package_x86
    } else {
      $package = $package_x64
    }

  } else {

    if $forthewin::sevenzip::x86_only {
      $installer = $installer_x86
      $package = $package_x86
    } else {
      if $facts[architecture] == 'x86' {
        # Choosing 7-Zip x86 for x86 Windows:
        $installer = $installer_x86
        $package = $package_x86
      } else {
        # Choosing 7-Zip x64 for x64 Windows:
        $installer = $installer_x64
        $package = $package_x64
      }
    }

  }

  info("[${trusted[certname]}] installer       = ${installer}")
  info("[${trusted[certname]}] package         = ${package}")

  package { $package:
    ensure          => present,
    source          => $installer,
    install_options => $install_options,
  }

}
