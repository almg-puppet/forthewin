class forthewin::thunderbird::preinstall {

  $data = $forthewin::thunderbird::legacy_profiles ? {true => 1, default => 0}
	registry_key { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Thunderbird':
      ensure => present,
    }
	->
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Thunderbird\LegacyProfiles':
    ensure => present,
    data => $data,
    type => 'dword',
  }


  unless empty($forthewin::thunderbird::installer_args) {
    if $forthewin::thunderbird::verbose {
      info("[${trusted[certname]}] Will create ${forthewin::thunderbird::config_ini}")
    }
    file { $forthewin::thunderbird::config_ini:
      ensure  => file,
      content => sprintf("; ${forthewin::params::default_header}[Install]\r\n%s", join($forthewin::thunderbird::installer_args, "\r\n")),
    }
  }

}