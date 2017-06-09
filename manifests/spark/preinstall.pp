class forthewin::spark::preinstall {

  # Remove unwanted software
  # https://forge.puppet.com/puppetlabs/stdlib#empty
  unless (empty($forthewin::spark::uninstall_list)) {

    if ($facts[architecture] == 'x64') {
      $registry_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    } else {
      $registry_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    }

    info('VARIABLES:')
    info("registry_key = ${registry_key}")
    info("forthewin::params::cmd = ${forthewin::params::cmd}")

    # Kills process before uninstall.
    # This is necessary because it is impossible to uninstall Spark while it is running.
    $forthewin::spark::uninstall_list.each |$item| {
      info("item = ${item}")
      exec { "Kill ${item}":
        command => "$forthewin::params::cmd /c taskkill /F /IM Spark.exe /T",
        returns => ['0', '1', '128', '3221225781'],
        onlyif  => "$forthewin::params::cmd /c reg query \"${registry_key}\\${item}\""
      }
      ->
      package { $item:
        ensure            => absent,
        uninstall_options => ['-q']
      }
    }

  }

}