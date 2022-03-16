class forthewin::thunderbird_legacy (
  String $config_filename = 'thunderbird.cfg',
  Boolean $config_only = false,
  Optional[String] $config_path = undef,
  Boolean $install_only = false,
  # https://wiki.mozilla.org/Installer:Command_Line_Arguments
  Array[String] $installer_args = [],
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\thunderbird",
  # https://en.wikipedia.org/wiki/IETF_language_tag
  # A single primary language subtag based on a two-letter language code from ISO 639-1 (2002) or a three-letter code from ISO 639-2 (1998), ISO 639-3 (2007) or ISO 639-5 (2008)
  # Optional: hyphen (-) followed by region subtag based on a two-letter country code from ISO 3166-1 alpha-2 (usually written in upper case)
  Pattern[/\A[a-z]{2,3}(?:-[A-Z]{2})?\Z/] $lang = 'en-US',
  Enum['win32', 'win64'] $os = 'win32',
  String $tempdir = $forthewin::params::tempdir,
  Boolean $uninstall_maintenance_service = true,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]{2,3}[.][0-9]{1,2}(?:[.][0-9]{1,2})?(?:esr)?\Z/] $version
  ) inherits forthewin::params {

  $config_ini = "${forthewin::thunderbird_legacy::tempdir}\\tb_config.ini"

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] config_filename               = ${config_filename}")
    info("[${trusted[certname]}] config_only                   = ${config_only}")
    info("[${trusted[certname]}] config_path                   = ${config_path}")
    info("[${trusted[certname]}] install_only                  = ${install_only}")
    info("[${trusted[certname]}] installer_args                = ${installer_args}")
    info("[${trusted[certname]}] installer_filename            = ${installer_filename}")
    info("[${trusted[certname]}] installer_path                = ${installer_path}")
    info("[${trusted[certname]}] lang                          = ${lang}")
    info("[${trusted[certname]}] os                            = ${os}")
    info("[${trusted[certname]}] tempdir                       = ${tempdir}")
    info("[${trusted[certname]}] uninstall_maintenance_service = ${uninstall_maintenance_service}")
    info("[${trusted[certname]}] version                       = ${version}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] config_ini                    = ${config_ini}")
  }

  if $config_only and $install_only {
    fail('Parameters config_only and install_only both set to TRUE - what do you want to do? Just install (install_only=true) or just config (config_only=true)? Default is to install AND config Thunderbird.')
  }

  unless $install_only {
    contain forthewin::thunderbird::config
  }

  unless $config_only {
    contain forthewin::thunderbird_legacy::preinstall
    contain forthewin::thunderbird_legacy::install
    Class['forthewin::thunderbird_legacy::preinstall'] -> Class['forthewin::thunderbird_legacy::install']
  }

  unless $config_only or $install_only {
    Class['forthewin::thunderbird_legacy::install'] -> Class['forthewin::thunderbird_legacy::config']
  }

}