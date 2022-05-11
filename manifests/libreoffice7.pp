class forthewin::libreoffice7 (
  Boolean $config_hklm = false,
  Optional[String] $custom_class = undef,
  Boolean $install_help_pack = false,
  Boolean $install_x86_only = false,
  String $installer_path = "${forthewin::params::repo_basepath}\\libreoffice",
  Boolean $verbose = $forthewin::params::verbose,
  String $version
  ) inherits forthewin::params {

  $is_libreoffice_running = str2bool($facts[is_libreoffice_running])

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] config_hklm            = ${config_hklm}")
    info("[${trusted[certname]}] custom_class           = ${custom_class}")
    info("[${trusted[certname]}] install_help_pack      = ${install_help_pack}")
    info("[${trusted[certname]}] install_x86_only       = ${install_x86_only}")
    info("[${trusted[certname]}] installer_path         = ${installer_path}")
    info("[${trusted[certname]}] version                = ${version}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] is_libreoffice_running = ${is_libreoffice_running}")
  }

  unless $is_libreoffice_running or $forthewin::params::platform in ['wxp', 'wvista'] {

    contain forthewin::libreoffice7::install

    if $config_hklm {
      contain forthewin::libreoffice7::config
      Class['forthewin::libreoffice7::install'] -> Class['forthewin::libreoffice7::config']
    }

    if $install_help_pack {
      contain forthewin::libreoffice7::help
      Class['forthewin::libreoffice7::install'] -> Class['forthewin::libreoffice7::help']
    }

    # If you want to customize anything, implement it in a class and use the
    # parameter "custom_class" for invocation. Be sure to control, inside this
    # class, the precedence of execution. For example:
    # Class['forthewin::firefox_esr::config'] -> Class['custom::firefox_esr']
    # or
    # Class['custom::firefox_esr'] -> Class['forthewin::firefox_esr::config']
    unless empty($custom_class) {
      if $verbose {
        notice("[${trusted[certname]}] Invoking class ${custom_class}")
      }
      contain $custom_class
    }

  }

}