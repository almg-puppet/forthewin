# http://www.itninja.com/software/microsoft/live-essentials/16-145
class forthewin::essentials2012 (
  String $installer_filename = 'wlsetup-all_2012.exe',
  String $installer_path = "${forthewin::params::repo_basepath}\\microsoft",
  Boolean $install_all = true,
  Boolean $install_familysafety = false,
  Boolean $install_mail = false,
  Boolean $install_messenger = false,
  Boolean $install_moviemaker = false,
  Boolean $install_skydrive = false,
  Boolean $install_writer = false,
  Array[String] $uninstall_list = [],
  String $version
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("installer_filename = ${installer_filename}")
  info("installer_path = ${installer_path}")
  info("install_all = ${install_all}")
  info("install_familysafety = ${install_familysafety}")
  info("install_mail = ${install_mail}")
  info("install_messenger = ${install_messenger}")
  info("install_moviemaker = ${install_moviemaker}")
  info("install_skydrive = ${install_skydrive}")
  info("install_writer = ${install_writer}")
  info("uninstall_list = ${uninstall_list}")
  info("version = ${version}")

  if $install_all == false and !($install_familysafety or $install_mail or $install_messenger or $install_moviemaker or $install_skydrive or $install_writer) {
    fail('With parameter install_all=false, you should choose at least one individual app to install.')
  }

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::essentials2012::preinstall
  contain forthewin::essentials2012::install

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::essentials2012::preinstall'] -> Class['forthewin::essentials2012::install']

}