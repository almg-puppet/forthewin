class forthewin::thunderbird (
  String $config_filename = 'thunderbird.cfg',
  Boolean $config_only = false,
  Optional[String] $config_path = undef,
  Boolean $crashreporter_disable = true,
  Optional[String] $custom_class = undef,
  Enum['auto', 'win32', 'win64'] $installer_arch = 'auto',
  # https://wiki.mozilla.org/Installer:Command_Line_Arguments
  Array[String] $installer_args = [],
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\thunderbird",
  Pattern[/\A[a-z]{2,3}(?:-[A-Z]{2})?\Z/] $lang = $forthewin::params::lang,
  Enum['win32', 'win64'] $os = 'win64',
  Boolean $legacy_profiles = false,
  Boolean $opt_desktop_shortcut = true,
  Boolean $opt_install_maintenance_service = false,
  Boolean $opt_start_menu_shortcut = true,
  Boolean $opt_taskbar_shortcut = true,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]{,3}[.][0-9]{,2}(?:[.][0-9])?\Z/] $version
  ) inherits forthewin::params {
  
  $config_ini = "${forthewin::thunderbird::tempdir}\\tb_config.ini"
  
  $is_thunderbird_running = str2bool($facts[is_thunderbird_running])

  # fail() interrupts the whole execution, err() does not.
  if $installer_arch == 'auto' and $installer_filename {
    err('When installer_filename is specified, installer_arch cannot be <auto>.')
    $error = true
  } elsif $facts[architecture] == 'x86' and $installer_arch == 'win64' {
    err('Cannot install Thunderbird 64-bit on a x86 architecture.')
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
    info("[${trusted[certname]}] lang                            = ${lang}")
    info("[${trusted[certname]}] legacy_profiles                 = ${legacy_profiles}")
    info("[${trusted[certname]}] opt_desktop_shortcut            = ${opt_desktop_shortcut}")
    info("[${trusted[certname]}] opt_install_maintenance_service = ${opt_install_maintenance_service}")
    info("[${trusted[certname]}] opt_start_menu_shortcut         = ${opt_start_menu_shortcut}")
    info("[${trusted[certname]}] opt_taskbar_shortcut            = ${opt_taskbar_shortcut}")
    info("[${trusted[certname]}] version                         = ${version}")
	 info("[${trusted[certname]}] is_thunderbird_running = ${is_thunderbird_running}")
  }

  unless $error {

    # Determines installer architecture
    if $installer_arch == 'auto' {
      $path_arch = $facts[architecture] ? {'x86' => 'win32', default => 'win64'}
    } else {
      $path_arch = $installer_arch
    }

    # TODO: adjust to cope with installer options INSTALL_DIRECTORY_PATH and INSTALL_DIRECTORY_NAME
    $thunderbird_home = sprintf('%s\%s', $path_arch ? {'win32' => $forthewin::params::programfiles32, default => $forthewin::params::programfiles}, 'Mozilla Thunderbird')

    if $verbose {
      info("[${trusted[certname]}] VARIABLES:")
      info("[${trusted[certname]}] path_arch    = ${path_arch}")
      info("[${trusted[certname]}] thunderbird_home = ${thunderbird_home}")
    }

	unless $is_thunderbird_running {
		# https://docs.puppet.com/puppet/latest/lang_containment.html
		contain forthewin::thunderbird::config
		unless $config_only {
			  contain forthewin::thunderbird::preinstall
			  contain forthewin::thunderbird::install
			  # https://docs.puppet.com/puppet/latest/lang_relationships.html
			  Class['forthewin::thunderbird::preinstall'] -> Class['forthewin::thunderbird::install'] -> Class['forthewin::thunderbird::config']
		

			# If you want to customize anything, implement it in a class and use the
			# parameter "custom_class" for invocation. Be sure to control, inside this
			# class, the precedence of execution. For example:
			# Class['forthewin::thunderbird::config'] -> Class['custom::thunderbird']
			# or
			# Class['custom::thunderbird'] -> Class['forthewin::thunderbird::config']
			unless empty($custom_class) {
			  if $verbose {
				notice("[${trusted[certname]}] Invoking class ${custom_class}")
				}
			  contain $custom_class
			  }
		}
	}
  }

}