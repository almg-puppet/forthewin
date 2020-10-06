# http://docs.oracle.com/javase/8/docs/technotes/guides/install/config.html#config_file_options
class forthewin::java (
  Optional[String] $custom_class = undef,
  Array[String] $default_options = ['/qn', 'INSTALL_SILENT=Enable', 'WEB_ANALYTICS=Disable'],
  Boolean $disable_autoupdate = true,
  Array[String] $exceptions_list = [],
  Boolean $install_x86_on_x64 = true,
  Boolean $install_x86_only = false,
  String $installer_path = "${forthewin::params::repo_basepath}\\java",
  Optional[String] $installer_x86_filename = undef,
  Optional[String] $installer_x64_filename = undef,
  Boolean $remove_auto_updater = true,
  Array[String] $uninstall_list = [],
  Boolean $verbose = $forthewin::params::verbose,
  String $version,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] custom_class           = ${custom_class}")
    info("[${trusted[certname]}] default_options        = ${default_options}")
    info("[${trusted[certname]}] disable_autoupdate     = ${disable_autoupdate}")
    info("[${trusted[certname]}] exceptions_list        = ${exceptions_list}")
    info("[${trusted[certname]}] install_x86_on_x64     = ${install_x86_on_x64}")
    info("[${trusted[certname]}] install_x86_only       = ${install_x86_only}")
    info("[${trusted[certname]}] installer_path         = ${installer_path}")
    info("[${trusted[certname]}] installer_x86_filename = ${installer_x86_filename}")
    info("[${trusted[certname]}] installer_x64_filename = ${installer_x64_filename}")
    info("[${trusted[certname]}] remove_auto_updater    = ${remove_auto_updater}")
    info("[${trusted[certname]}] uninstall_list         = ${uninstall_list}")
    info("[${trusted[certname]}] version                = ${version}")
  }

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::java::install
  contain forthewin::java::config

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::java::install'] -> Class['forthewin::java::config']

  # If you want to customize anything, implement it in a class and use the
  # parameter "custom_class" for invocation. Be sure to control, inside this
  # class, the precedence of execution. For example:
  # Class['forthewin::java::config'] -> Class['custom::java']
  # or
  # Class['custom::java'] -> Class['forthewin::java::config']
  unless empty($custom_class) {
    if $verbose {
      warning("[${trusted[certname]}] Invoking class ${custom_class}")
    }
    contain $custom_class
  }

}