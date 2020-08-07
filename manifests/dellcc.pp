class forthewin::dellcc (
  Array[String] $install_options = [],
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\dell",
  Array[String] $installfor_productname = [],
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  # Full path to installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\Command_Configure-${version}.msi"
  }

  # Equipament's manufacturer and model
  $manufacturer = $facts[manufacturer]
  $is_dell = $manufacturer == 'Dell Inc.'
  $productname = $facts[productname]

  # If installfor_productname is not provided, then install for *ANY* Dell model
  if empty($installfor_productname) {
    $condition = $is_dell
  } else {
    $condition = $is_dell and $productname in $installfor_productname
  }

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] install_options        = ${install_options}")
    info("[${trusted[certname]}] installer_filename     = ${installer_filename}")
    info("[${trusted[certname]}] installer_path         = ${installer_path}")
    info("[${trusted[certname]}] installfor_productname = ${installfor_productname}")
    info("[${trusted[certname]}] version                = ${version}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] condition              = ${condition}")
    info("[${trusted[certname]}] installer              = ${installer}")
    info("[${trusted[certname]}] is_dell                = ${is_dell}")
    info("[${trusted[certname]}] manufacturer           = ${manufacturer}")
    info("[${trusted[certname]}] productname            = ${productname}")
  }

  if $condition {
    package { 'Dell Command | Configure':
      ensure          => $version,
      source          => $installer,
      install_options => $install_options,
    }
  }

}