# https://download.gimp.org/mirror/pub/gimp/
class forthewin::gimp (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\gimp",
  Pattern[/\A[a-z]{2,3}(?:-[A-Z]{2})?\Z/] $lang = 'en-US',
  Array[String] $uninstall_list = [],
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  info("[${trusted[certname]}] PARAMETERS:")
  info("[${trusted[certname]}] installer_filename = ${installer_filename}")
  info("[${trusted[certname]}] installer_path     = ${installer_path}")
  info("[${trusted[certname]}] lang               = ${lang}")
  info("[${trusted[certname]}] uninstall_list     = ${uninstall_list}")
  info("[${trusted[certname]}] version            = ${version}")

  # Is GIMP running?
  # It only checks for version 2.8!
  $is_gimp_running = str2bool($facts[is_gimp_running])

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] is_gimp_running = ${is_gimp_running}")

  unless $is_gimp_running {

    # https://docs.puppet.com/puppet/latest/lang_containment.html
    contain forthewin::gimp::install
    contain forthewin::gimp::postinstall

    # https://docs.puppet.com/puppet/latest/lang_relationships.html
    Class['forthewin::gimp::install'] -> Class['forthewin::gimp::postinstall']

  }

}