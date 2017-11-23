# http://www.7-zip.org/download.html
class forthewin::sevenzip (
  Optional[Enum['x86', 'x64']] $installer_arch = undef,
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\7zip",
  Array[String] $uninstall_list = [],
  Pattern[/\A[0-9]+[.][0-9]+\Z/] $version,
  Boolean $x86_only = false,
  ) inherits forthewin::params {

  info("[${trusted[certname]}] PARAMETERS:")
  info("[${trusted[certname]}] installer_arch     = ${installer_arch}")
  info("[${trusted[certname]}] installer_filename = ${installer_filename}")
  info("[${trusted[certname]}] installer_path     = ${installer_path}")
  info("[${trusted[certname]}] uninstall_list     = ${uninstall_list}")
  info("[${trusted[certname]}] version            = ${version}")
  info("[${trusted[certname]}] x86_only           = ${x86_only}")

  # Install options of the resource package
  $install_options = ["/qn"]

  # Version without dots "."
  $v = regsubst($version, '[.]', '', 'G')

  # x86 and x64 patterns of the installer filename
  $installer_x86 = "${installer_path}\\7z${v}.msi"
  $installer_x64 = "${installer_path}\\7z${v}-x64.msi"

  # x86 and x64 patterns for the package name
  $package_x86 = "7-Zip ${version}"
  $package_x64 = "7-Zip ${version} (x64 edition)"

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] install_options = ${install_options}")
  info("[${trusted[certname]}] installer_x86   = ${installer_x86}")
  info("[${trusted[certname]}] installer_x64   = ${installer_x64}")
  info("[${trusted[certname]}] package_x86     = ${package_x86}")
  info("[${trusted[certname]}] package_x64     = ${package_x64}")
  info("[${trusted[certname]}] v               = ${v}")

  # Full path to installer
  if $installer_filename {

    unless $installer_arch {
      fail("[${trusted[certname]}] Please inform a value for parameter 'installer_arch'")
    }
    $installer = "${installer_path}\\${installer_filename}"

  } else {

    if $x86_only {
      $installer = $installer_x86
    } else {
      if $facts[architecture] == 'x86' {
        # Choosing 7-Zip x86 for x86 Windows:
        $installer = $installer_x86
      } else {
        # Choosing 7-Zip x64 for x64 Windows:
        $installer = $installer_x64
      }
    }

  }

  # Choose package name accordingly
  case $installer {
    $installer_x86: { $package = $package_x86 }
    $installer_x64: { $package = $package_x64 }
    default: {
      if $installer_arch == 'x86' {
        $package = $package_x86
      } else {
        $package = $package_x64
      }
    }
  }

  info("[${trusted[certname]}] installer       = ${installer}")
  info("[${trusted[certname]}] package         = ${package}")

  # Remove unwanted software
  unless (empty($uninstall_list)) {
    package { $uninstall_list:
      ensure => absent,
      before => Package[$package]
    }
  }

	package { $package:
		ensure          => present,
		source          => $installer,
		install_options => $install_options,
	}

}
