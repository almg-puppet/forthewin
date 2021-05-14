class forthewin::firefox::config {

  if /(?i:InstallDirectoryPath)/ in $forthewin::firefox::installer_args {
    $firefox_home = regsubst(grep($forthewin::firefox::installer_args, '(?i:InstallDirectoryPath)')[0], '\A\W*InstallDirectoryPath\W+(.*?)\W*\Z', '\1', 'I')
  } else {
    if /(?i:InstallDirectoryName)/ in $forthewin::firefox::installer_args {
      $dirname = regsubst(grep($forthewin::firefox::installer_args, '(?i:InstallDirectoryName)')[0], '\A\W*InstallDirectoryName\W+(.*?)\W*\Z', '\1', 'I')
    } else {
      $dirname = 'Mozilla Firefox'
    }
    $firefox_home = sprintf('%s\%s', $forthewin::firefox::os ? {'win32' => $forthewin::params::programfiles32, default => $forthewin::params::programfiles}, $dirname)
  }

  if $forthewin::firefox::disable_profile_migrator {

    # Full path to override.ini in destination
    $override_dst = "${firefox_home}\\browser\\override.ini"

    file { $override_dst:
      ensure => file,
      content => "; ${forthewin::params::default_header}[XRE]\r\nEnableProfileMigrator=false\r\n",
    }

  }

  if $forthewin::firefox::enable_autoconfig {

    # Full path to autoconfig.js in destination
    $autoconfig_dst = "${firefox_home}\\defaults\\pref\\_autoconfig.js"
    # Full path to Firefox's customized settings, source and destination
    if $forthewin::firefox::config_path {
      $mozillacfg_src = "${forthewin::firefox::config_path}/${forthewin::firefox::config_filename}"
    } else {
      $mozillacfg_src = "${forthewin::firefox::installer_path}/${forthewin::firefox::version}/${forthewin::firefox::config_filename}"
    }
    $mozillacfg_dst = "${firefox_home}\\mozilla.cfg"

    file { $mozillacfg_dst:
      backup => false,
      ensure => file,
      source => $mozillacfg_src,
    }
    ->
    file { $autoconfig_dst:
      backup => false,
      ensure => file,
      content => "// ${forthewin::params::default_header}pref(\"general.config.obscure_value\", 0);\r\npref(\"general.config.filename\", \"mozilla.cfg\");\r\n",
    }

  }

  if $forthewin::firefox::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] autoconfig_dst = ${autoconfig_dst}")
    info("[${trusted[certname]}] dirname        = ${dirname}")
    info("[${trusted[certname]}] firefox_home   = ${firefox_home}")
    info("[${trusted[certname]}] mozillacfg_dst = ${mozillacfg_dst}")
    info("[${trusted[certname]}] mozillacfg_src = ${mozillacfg_src}")
    info("[${trusted[certname]}] override_dst   = ${override_dst}")
  }

}
