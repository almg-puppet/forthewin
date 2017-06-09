# http://docs.oracle.com/javase/8/docs/technotes/guides/install/config.html#config_file_options
class forthewin::java (
  Boolean $install_x86_on_x64 = true,
  Array[String] $default_options = ['/qn', 'INSTALL_SILENT=Enable', 'WEB_ANALYTICS=Disable'],
  Boolean $disable_autoupdate = true,
  Array[String] $exceptions_list = [],
  String $installer_path = "${forthewin::params::repo_basepath}\\java",
  Optional[String] $installer_x86_filename = undef,
  Optional[String] $installer_x64_filename = undef,
  Boolean $remove_auto_updater = true,
  Array[String] $uninstall_list = [],
  String $version,
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("install_x86_on_x64 = ${install_x86_on_x64}")
  info("default_options = ${default_options}")
  info("disable_autoupdate = ${disable_autoupdate}")
  info("exceptions_list = ${exceptions_list}")
  info("installer_path = ${installer_path}")
  info("installer_x86_filename = ${installer_x86_filename}")
  info("installer_x64_filename = ${installer_x64_filename}")
  info("remove_auto_updater = ${remove_auto_updater}")
  info("uninstall_list = ${uninstall_list}")
  info("version = ${version}")

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::java::install
  contain forthewin::java::config

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::java::install'] -> Class['forthewin::java::config']
}