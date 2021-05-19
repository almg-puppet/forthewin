# Patches and istallation sources:
# Adobe Reader XI: ftp://ftp.adobe.com/pub/adobe/reader/win/11.x/
# Adobe Reader DC: ftp://ftp.adobe.com/pub/adobe/reader/win/AcrobatDC/
class forthewin::adobereader (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\adobe",
  Optional[String] $installer_update_filename = undef,
  Enum['XI', 'DC'] $managed_version = 'XI',
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] installer_filename        = ${installer_filename}")
    info("[${trusted[certname]}] installer_update_filename = ${installer_update_filename}")
    info("[${trusted[certname]}] managed_version           = ${managed_version}")
    info("[${trusted[certname]}] full version              = ${version}")
  }

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::adobereader::install

}