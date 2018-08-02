# https://download.gimp.org/mirror/pub/gimp/
class forthewin::gimp (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\gimp",
  Array[String] $install_options = ['/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', "/LANG=${forthewin::params::lang}"],
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  info("[${trusted[certname]}] PARAMETERS:")
  info("[${trusted[certname]}] installer_filename = ${installer_filename}")
  info("[${trusted[certname]}] installer_path     = ${installer_path}")
  info("[${trusted[certname]}] install_options    = ${install_options}")
  info("[${trusted[certname]}] version            = ${version}")

  # Is GIMP running?
  $is_gimp_running = str2bool($facts[is_gimp_running])

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] is_gimp_running = ${is_gimp_running}")

  unless $is_gimp_running {

    # https://docs.puppet.com/puppet/latest/lang_containment.html
    contain forthewin::gimp::install

  }

}