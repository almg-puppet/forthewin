# https://admx.help/?Category=Firefox&Policy=Mozilla.Policies.Firefox::LegacyProfiles
class forthewin::firefox_esr::preinstall {

  $data = $forthewin::firefox_esr::legacy_profiles ? {true => 1, default => 0}
  $username = $facts[username]

  if $forthewin::firefox_esr::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] data     = ${data}")
    info("[${trusted[certname]}] username = ${username}")
  }

  windows_env { 'sys.MOZ_LEGACY_PROFILES':
    ensure    => absent,
    mergemode => clobber,
    variable  => 'MOZ_LEGACY_PROFILES',
  }

  unless $username == 'unknown' { 
    windows_env { 'user.MOZ_LEGACY_PROFILES':
      ensure    => absent,
      mergemode => clobber,
      user      => $username,
      variable  => 'MOZ_LEGACY_PROFILES',
    }
  }

  registry::value { 'LegacyProfiles':
    key  => 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox',
    data => $data,
    type => 'dword',
  }

}