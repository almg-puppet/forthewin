class forthewin::dellcc (
  Array[String] $install_options = [],
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\dell",
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  # Full path to installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\Command_Configure-${version}.msi"
  }

  # Equipament's manufacturer
  $manufacturer = $facts[manufacturer]

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] install_options    = ${install_options}")
    info("[${trusted[certname]}] installer_filename = ${installer_filename}")
    info("[${trusted[certname]}] installer_path     = ${installer_path}")
    info("[${trusted[certname]}] version            = ${version}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] installer          = ${installer}")
    info("[${trusted[certname]}] manufacturer       = ${manufacturer}")
  }

  if $manufacturer == 'Dell Inc.' {
    package { 'Dell Command | Configure':
      ensure          => $version,
      source          => $installer,
      install_options => $install_options,
    }
  }

}