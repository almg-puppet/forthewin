class forthewin::firefox_esr (
  String $config_filename = 'policies.json',
  Boolean $config_only = false,
  Optional[String] $config_path = undef,
  Boolean $crashreporter_disable = true,
  Optional[String] $custom_class = undef,
  Enum['auto', 'win32', 'win64'] $installer_arch = 'auto',
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\firefox",
  Boolean $legacy_profiles = false,
  Boolean $opt_desktop_shortcut = true,
  Boolean $opt_install_maintenance_service = false,
  Boolean $opt_start_menu_shortcut = true,
  Boolean $opt_taskbar_shortcut = true,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]{,3}[.][0-9]{,2}(?:[.][0-9])?esr\Z/] $version
  ) inherits forthewin::params {

  # fail() interrupts the whole execution, err() does not.
  if $installer_arch == 'auto' and $installer_filename {
    err('When installer_filename is specified, installer_arch cannot be <auto>.')
    $error = true
  } elsif $facts[architecture] == 'x86' and $installer_arch == 'win64' {
    err('Cannot install Firefox ESR 64-bit on a x86 architecture.')
    $error = true
  } else {
    $error = false
  }
  
  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] config_filename                 = ${config_filename}")
    info("[${trusted[certname]}] config_only                     = ${config_only}")
    info("[${trusted[certname]}] config_path                     = ${config_path}")
    info("[${trusted[certname]}] crashreporter_disable           = ${crashreporter_disable}")
    info("[${trusted[certname]}] custom_class                    = ${custom_class}")
    info("[${trusted[certname]}] installer_arch                  = ${installer_arch}")
    info("[${trusted[certname]}] installer_filename              = ${installer_filename}")
    info("[${trusted[certname]}] installer_path                  = ${installer_path}")
    info("[${trusted[certname]}] legacy_profiles                 = ${legacy_profiles}")
    info("[${trusted[certname]}] opt_desktop_shortcut            = ${opt_desktop_shortcut}")
    info("[${trusted[certname]}] opt_install_maintenance_service = ${opt_install_maintenance_service}")
    info("[${trusted[certname]}] opt_start_menu_shortcut         = ${opt_start_menu_shortcut}")
    info("[${trusted[certname]}] opt_taskbar_shortcut            = ${opt_taskbar_shortcut}")
    info("[${trusted[certname]}] verbose                         = ${verbose}")
    info("[${trusted[certname]}] version                         = ${version}")
  }

  unless $error {

    # Determines installer architecture
    if $installer_arch == 'auto' {
      $path_arch = $facts[architecture] ? {'x86' => 'win32', default => 'win64'}
    } else {
      $path_arch = $installer_arch
    }

    # TODO: adjust to cope with installer options INSTALL_DIRECTORY_PATH and INSTALL_DIRECTORY_NAME
    $firefox_home = sprintf('%s\%s', $path_arch ? {'win32' => $forthewin::params::programfiles32, default => $forthewin::params::programfiles}, 'Mozilla Firefox')

    if $verbose {
      info("[${trusted[certname]}] VARIABLES:")
      info("[${trusted[certname]}] path_arch    = ${path_arch}")
      info("[${trusted[certname]}] firefox_home = ${firefox_home}")
    }

    # https://docs.puppet.com/puppet/latest/lang_containment.html
    contain forthewin::firefox_esr::config
    unless $config_only {
      contain forthewin::firefox_esr::preinstall
      contain forthewin::firefox_esr::install
      # https://docs.puppet.com/puppet/latest/lang_relationships.html
      Class['forthewin::firefox_esr::preinstall'] -> Class['forthewin::firefox_esr::install'] -> Class['forthewin::firefox_esr::config']
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