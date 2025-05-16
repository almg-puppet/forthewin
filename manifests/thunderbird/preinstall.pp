class forthewin::thunderbird::preinstall {

  $data = $forthewin::thunderbird::legacy_profiles ? {true => 1, default => 0}
  registry_key { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Thunderbird':
    ensure => present,
  }
  ->
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Thunderbird\LegacyProfiles':
    ensure => present,
    data   => $data,
    type   => 'dword',
  }

}