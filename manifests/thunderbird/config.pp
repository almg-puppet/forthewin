class forthewin::thunderbird::config {

  if /(?i:InstallDirectoryPath)/ in $forthewin::thunderbird::installer_args {
    $thunderbird_home = regsubst(grep($forthewin::thunderbird::installer_args, '(?i:InstallDirectoryPath)')[0], '\A\W*InstallDirectoryPath\W+(.*?)\W*\Z', '\1', 'I')
  } else {
    if /(?i:InstallDirectoryName)/ in $forthewin::thunderbird::installer_args {
      $dirname = regsubst(grep($forthewin::thunderbird::installer_args, '(?i:InstallDirectoryName)')[0], '\A\W*InstallDirectoryName\W+(.*?)\W*\Z', '\1', 'I')
    } else {
      $dirname = 'Mozilla Thunderbird'
    }
    $thunderbird_home = sprintf('%s\%s', $forthewin::thunderbird::os ? {'win32' => $forthewin::params::programfiles32, default => $forthewin::params::programfiles}, $dirname)
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

	# 	Migration to policies. For TB 68+, configurations can be done using policies_filename ( https://github.com/thundernest/policy-templates/tree/master/templates/esr91 )
	# but, not all configurations are available yet, so you can continue using prefs file and migrate configurations to policies as they are implemented. 
	#   If policies_filename is set, the class will configure them in addition to the config file. 
	#   IMPORTANT: Make sure not to set the same configuration in both files to avoid conflicts.
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

  if $forthewin::thunderbird::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] autoconfig_dst   = ${autoconfig_dst}")
    info("[${trusted[certname]}] dirname          = ${dirname}")
    info("[${trusted[certname]}] mozillacfg_dst   = ${mozillacfg_dst}")
    info("[${trusted[certname]}] mozillacfg_src   = ${mozillacfg_src}")
    info("[${trusted[certname]}] thunderbird_home = ${thunderbird_home}")
	unless empty($forthewin::thunderbird::policies_filename) {
    info("[${trusted[certname]}] policies_dst         = ${policies_dst}")
    info("[${trusted[certname]}] policies_home        = ${policies_home}")
    info("[${trusted[certname]}] policies_src         = ${policies_src}")
    info("[${trusted[certname]}] policies_src_slashed = ${policies_src_slashed}")
	}
  }

}