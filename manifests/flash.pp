# https://get.adobe.com/br/flashplayer/otherversions/
# https://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html
# http://www.adobe.com/devnet/flashplayer/articles/flash_player_admin_guide.html
class forthewin::flash (
  Boolean $disable_autoupdate = true,
  Boolean $enable_silent_autoupdate = false,
  Boolean $install_activex = true,
  Boolean $install_npapi = true,
  Boolean $install_ppapi = false,
  String $installer_path = "${forthewin::params::repo_basepath}\\adobe",
  Optional[String] $installer_activex_filename = undef,
  Optional[String] $installer_npapi_filename = undef,
  Optional[String] $installer_ppapi_filename = undef,
  Hash $settings = {},
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] disable_autoupdate         = ${disable_autoupdate}")
    info("[${trusted[certname]}] enable_silent_autoupdate   = ${enable_silent_autoupdate}")
    info("[${trusted[certname]}] install_activex            = ${install_activex}")
    info("[${trusted[certname]}] install_npapi              = ${install_npapi}")
    info("[${trusted[certname]}] install_ppapi              = ${install_ppapi}")
    info("[${trusted[certname]}] installer_activex_filename = ${installer_activex_filename}")
    info("[${trusted[certname]}] installer_npapi_filename   = ${installer_npapi_filename}")
    info("[${trusted[certname]}] installer_path             = ${installer_path}")
    info("[${trusted[certname]}] installer_ppapi_filename   = ${installer_ppapi_filename}")
    info("[${trusted[certname]}] settings                   = ${settings}")
    info("[${trusted[certname]}] version                    = ${version}")
  }

  # TODO: obtain path using facts
  $mmscfg_path = $::architecture ? {
    'x64' => 'C:/Windows/SysWOW64/Macromed/Flash/mms.cfg',
    'x86' => 'C:/Windows/system32/Macromed/Flash/mms.cfg',
  }

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] mmscfg_path = ${mmscfg_path}")
  }

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::flash::install
  contain forthewin::flash::config
  contain forthewin::flash::postconfig

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::flash::install'] -> Class['forthewin::flash::config'] -> Class['forthewin::flash::postconfig']
}