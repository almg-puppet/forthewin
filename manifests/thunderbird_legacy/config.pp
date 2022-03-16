class forthewin::thunderbird_legacy::config {

  if /(?i:InstallDirectoryPath)/ in $forthewin::thunderbird_legacy::installer_args {
    $thunderbird_home = regsubst(grep($forthewin::thunderbird_legacy::installer_args, '(?i:InstallDirectoryPath)')[0], '\A\W*InstallDirectoryPath\W+(.*?)\W*\Z', '\1', 'I')
  } else {
    if /(?i:InstallDirectoryName)/ in $forthewin::thunderbird_legacy::installer_args {
      $dirname = regsubst(grep($forthewin::thunderbird_legacy::installer_args, '(?i:InstallDirectoryName)')[0], '\A\W*InstallDirectoryName\W+(.*?)\W*\Z', '\1', 'I')
    } else {
      $dirname = 'Mozilla Thunderbird'
    }
    $thunderbird_home = sprintf('%s\%s', $forthewin::thunderbird_legacy::os ? {'win32' => $forthewin::params::programfiles32, default => $forthewin::params::programfiles}, $dirname)
  }

  # Full path to autoconfig.js in destination
  $autoconfig_dst = "${thunderbird_home}\\defaults\\pref\\autoconfig.js"
  # Full path to Thunderbird's customized settings, source and destination
  if $forthewin::thunderbird_legacy::config_path {
    $mozillacfg_src = "${forthewin::thunderbird_legacy::config_path}/${forthewin::thunderbird_legacy::config_filename}"
  } else {
    $mozillacfg_src = "${forthewin::thunderbird_legacy::installer_path}/${forthewin::thunderbird_legacy::version}/${forthewin::thunderbird_legacy::config_filename}"
  }
  $mozillacfg_dst = "${thunderbird_home}\\mozilla.cfg"

  file { $mozillacfg_dst:
    ensure => file,
    source => $mozillacfg_src,
  }
  ->
  file { $autoconfig_dst:
    ensure => file,
    content => "// ${forthewin::params::default_header}pref(\"general.config.obscure_value\", 0);\r\npref(\"general.config.filename\", \"mozilla.cfg\");\r\n",
  }

  if $forthewin::thunderbird_legacy::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] autoconfig_dst   = ${autoconfig_dst}")
    info("[${trusted[certname]}] dirname          = ${dirname}")
    info("[${trusted[certname]}] mozillacfg_dst   = ${mozillacfg_dst}")
    info("[${trusted[certname]}] mozillacfg_src   = ${mozillacfg_src}")
    info("[${trusted[certname]}] thunderbird_home = ${thunderbird_home}")
  }

}