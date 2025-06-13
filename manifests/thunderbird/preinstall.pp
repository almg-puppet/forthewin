class forthewin::thunderbird::preinstall {

  registry_key { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Thunderbird':
    ensure => present,
  }

}