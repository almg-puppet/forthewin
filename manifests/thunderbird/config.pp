class forthewin::thunderbird::config {

  if $forthewin::thunderbird::opt_install_dirpath {
    $thunderbird_home = $forthewin::thunderbird::opt_install_dirpath
  } else {
    if $forthewin::thunderbird::opt_install_dirname {
      $dirname = $forthewin::thunderbird::opt_install_dirname
    } else {
      $dirname = 'Mozilla Thunderbird'
    }
    $thunderbird_home = sprintf('%s\%s', ($forthewin::thunderbird::path_arch == 'win32' and $facts[architecture] == 'x64') ? {true => $forthewin::params::programfiles32, default => $forthewin::params::programfiles}, $dirname)
  }

  # Full path to autoconfig.js in destination
  $autoconfig_dst = "${thunderbird_home}\\defaults\\pref\\autoconfig.js"
  # Full path to Thunderbird's customized settings, source and destination
  if $forthewin::thunderbird::config_path {
    $mozillacfg_src = "${forthewin::thunderbird::config_path}/${forthewin::thunderbird::config_filename}"
  } else {
    $mozillacfg_src = "${forthewin::thunderbird::installer_path}/${forthewin::thunderbird::version}/${forthewin::thunderbird::config_filename}"
  }
  $mozillacfg_dst = "${thunderbird_home}\\mozilla.cfg"

  if $forthewin::thunderbird::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] autoconfig_dst   = ${autoconfig_dst}")
    info("[${trusted[certname]}] dirname          = ${dirname}")
    info("[${trusted[certname]}] mozillacfg_dst   = ${mozillacfg_dst}")
    info("[${trusted[certname]}] mozillacfg_src   = ${mozillacfg_src}")
    info("[${trusted[certname]}] thunderbird_home = ${thunderbird_home}")
  }

  file { $mozillacfg_dst:
    ensure => file,
    source => $mozillacfg_src,
  }
  ->
  file { $autoconfig_dst:
    ensure => file,
    content => "// ${forthewin::params::default_header}pref(\"general.config.obscure_value\", 0);\r\npref(\"general.config.filename\", \"mozilla.cfg\");\r\n",
  }

  # Disable Autoconfig (Versions 72+)
  registry::value { 'DisableAppUpdate':
    key  => 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Thunderbird',
    data => '00000001',
    type => 'dword',
  }

  # Migration to policies. For TB 68+, configurations
  # can be done using policies_filename:
  # https://github.com/thundernest/policy-templates/tree/master/templates/esr91
  # However, not all configurations are available yet, so you can continue using
  # prefs file and migrate configurations to policies as they are implemented.
  # If policies_filename is set, the class will configure them in addition to the config file.
  # IMPORTANT: Make sure not to set the same configuration in both files to avoid conflicts.
  unless empty($forthewin::thunderbird::policies_filename) {

    # Full path to Thunderbirds's customized settings, source and destination
    if $forthewin::thunderbird::config_path {
      $policies_src = "${forthewin::thunderbird::config_path}\\${forthewin::thunderbird::policies_filename}"
    } else {
      $policies_src = "${forthewin::thunderbird::installer_path}\\${forthewin::thunderbird::version}\\${forthewin::thunderbird::policies_filename}"
    }

    if $policies_src =~ /^puppet:/ {
      $policies_src_slashed = regsubst($policies_src, '\\\\', '/', 'G')
    } else {
      $policies_src_slashed = $policies_src
    }

    $policies_home = "${thunderbird_home}\\distribution"
    $policies_dst = "${policies_home}\\policies.json"

    if $forthewin::thunderbird::verbose {
      info("[${trusted[certname]}] policies_dst         = ${policies_dst}")
      info("[${trusted[certname]}] policies_home        = ${policies_home}")
      info("[${trusted[certname]}] policies_src         = ${policies_src}")
      info("[${trusted[certname]}] policies_src_slashed = ${policies_src_slashed}")
    }

    # Creates policies.json
    # https://github.com/mozilla/policy-templates
    file { $policies_home:
      ensure => directory
    }
    ->
    file { $policies_dst:
      ensure => file,
      source => $policies_src_slashed
    }

  }

}