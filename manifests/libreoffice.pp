class forthewin::libreoffice (
  Boolean $check_for_updates               = false,
  Boolean $create_desktop_link             = true,
  Boolean $enable_quickstart               = false,
  Optional[String] $help_pack_filename     = undef,
  Array[String] $help_pack_install_options = ['/qn'],
  String $help_pack_lang                   = 'en-US',
  String $help_pack_lang_name              = 'English (United States)',
  Optional[String] $help_pack_path         = undef,
  Boolean $install_all_features            = true,
  Boolean $install_help_pack               = false,
  Array[String] $install_options           = ['/qn', 'ADDLOCAL=ALL', 'ALLUSERS=1', 'VC_REDIST=1'],
  Boolean $install_x86_only                = true,
  String $installer_path                   = "${forthewin::params::repo_basepath}\\libreoffice",
  Optional[String] $installer_filename     = undef,
  Boolean $reboot_after_install            = false,
  Boolean $register_mso_types              = false,
  Boolean $remove_online_update            = true,
  Array[String] $ui_langs                  = ['en_US'],
  Array[String] $remove_features           = [],
  String $version
  ) inherits forthewin::params {

  info("[${trusted[certname]}] PARAMETERS:")
  info("[${trusted[certname]}] check_for_updates         = ${check_for_updates}")
  info("[${trusted[certname]}] create_desktop_link       = ${create_desktop_link}")
  info("[${trusted[certname]}] enable_quickstart         = ${enable_quickstart}")
  info("[${trusted[certname]}] help_pack_filename        = ${help_pack_filename}")
  info("[${trusted[certname]}] help_pack_install_options = ${help_pack_install_options}")
  info("[${trusted[certname]}] help_pack_lang            = ${help_pack_lang}")
  info("[${trusted[certname]}] help_pack_lang_name       = ${help_pack_lang_name}")
  info("[${trusted[certname]}] help_pack_path            = ${help_pack_path}")
  info("[${trusted[certname]}] install_all_features      = ${install_all_features}")
  info("[${trusted[certname]}] install_help_pack         = ${install_help_pack}")
  info("[${trusted[certname]}] install_options           = ${install_options}")
  info("[${trusted[certname]}] install_x86_only          = ${install_x86_only}")
  info("[${trusted[certname]}] installer_path            = ${installer_path}")
  info("[${trusted[certname]}] installer_filename        = ${installer_filename}")
  info("[${trusted[certname]}] reboot_after_install      = ${reboot_after_install}")
  info("[${trusted[certname]}] register_mso_types        = ${register_mso_types}")
  info("[${trusted[certname]}] remove_online_update      = ${remove_online_update}")
  info("[${trusted[certname]}] ui_langs                  = ${ui_langs}")
  info("[${trusted[certname]}] remove_features           = ${remove_features}")
  info("[${trusted[certname]}] version                   = ${version}")

  if ($check_for_updates and $remove_online_update) {
    fail('Parameters check_for_updates and remove_online_update both set to TRUE - what do you want to do? Leave the online update feature installed and checking for updates ou remove the feature for good?')
  }

  $is_libreoffice_running = str2bool($facts[is_libreoffice_running])
  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] is_libreoffice_running    = ${is_libreoffice_running}")

  unless $is_libreoffice_running or $forthewin::params::platform in ['wxp', 'wvista'] {

    # https://docs.puppet.com/puppet/latest/lang_containment.html
    contain forthewin::libreoffice::install
    contain forthewin::libreoffice::help

    # https://docs.puppet.com/puppet/latest/lang_relationships.html
    Class['forthewin::libreoffice::install'] -> Class['forthewin::libreoffice::help']

  }

}