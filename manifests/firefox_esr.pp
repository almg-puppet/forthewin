class forthewin::firefox_esr (
  Optional[String] $custom_class = undef,
  Enum['auto', 'win32', 'win64'] $installer_arch = 'auto',
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\firefox",
  Boolean $opt_desktop_shortcut = true,
  Boolean $opt_install_maintenance_service = false,
  Boolean $opt_start_menu_shortcut = true,
  Boolean $opt_taskbar_shortcut = true,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]{,3}[.][0-9]{,2}(?:[.][0-9])?esr\Z/] $version
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] custom_class                    = ${custom_class}")
    info("[${trusted[certname]}] installer_arch                  = ${installer_arch}")
    info("[${trusted[certname]}] installer_filename              = ${installer_filename}")
    info("[${trusted[certname]}] installer_path                  = ${installer_path}")
    info("[${trusted[certname]}] opt_desktop_shortcut            = ${opt_desktop_shortcut}")
    info("[${trusted[certname]}] opt_install_maintenance_service = ${opt_install_maintenance_service}")
    info("[${trusted[certname]}] opt_start_menu_shortcut         = ${opt_start_menu_shortcut}")
    info("[${trusted[certname]}] opt_taskbar_shortcut            = ${opt_taskbar_shortcut}")
    info("[${trusted[certname]}] verbose                         = ${verbose}")
    info("[${trusted[certname]}] version                         = ${version}")
  }

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::firefox_esr::preinstall
  contain forthewin::firefox_esr::install
  contain forthewin::firefox_esr::config

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::firefox_esr::preinstall'] -> Class['forthewin::firefox_esr::install'] -> Class['forthewin::firefox_esr::config']

  # If you want to customize anything, implement it in a class and use the
  # parameter "custom_class" for invocation. Be sure to control, inside this
  # class, the precedence of execution. For example:
  # Class['forthewin::firefox_esr::config'] -> Class['custom::firefox_esr']
  # or
  # Class['custom::firefox_esr'] -> Class['forthewin::firefox_esr::config']
  unless empty($custom_class) {
    if $verbose {
      warning("[${trusted[certname]}] Invoking class ${custom_class}")
    }
    contain $custom_class
  }

}