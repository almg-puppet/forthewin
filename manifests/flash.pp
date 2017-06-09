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
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("disable_autoupdate = ${disable_autoupdate}")
  info("enable_silent_autoupdate = ${enable_silent_autoupdate}")
  info("install_activex = ${install_activex}")
  info("install_npapi = ${install_npapi}")
  info("install_ppapi = ${install_ppapi}")
  info("installer_path = ${installer_path}")
  info("installer_activex_filename = ${installer_activex_filename}")
  info("installer_npapi_filename = ${installer_npapi_filename}")
  info("installer_ppapi_filename = ${installer_ppapi_filename}")
  info("settings = ${settings}")
  info("version = ${version}")

  # TODO: obtain path using facts
  $mmscfg_path = $::architecture ? {
    'x64' => 'C:/Windows/SysWOW64/Macromed/Flash/mms.cfg',
    'x86' => 'C:/Windows/system32/Macromed/Flash/mms.cfg',
  }
  info('VARIABLES:')
  info("mmscfg_path = ${mmscfg_path}")
  
  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::flash::install
  contain forthewin::flash::config
  contain forthewin::flash::postconfig

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::flash::install'] -> Class['forthewin::flash::config'] -> Class['forthewin::flash::postconfig']
}