class forthewin::spark::preinstall {

  # The preinstall procedure kills the Spark process BEFORE updating, but
  # ONLY IF the installed version is different from the one we're trying do install.
  # This works for version 2.7 and above. If your scenario requires other preinstall tasks
  # you can implement them in a class and use parameter "preinstall_class" for invocation.
  unless  empty($forthewin::spark::preinstall_class) {
    if $forthewin::spark::verbose {
      warning("[${trusted[certname]}] Invoking class ${forthewin::spark::preinstall_class}")
    }
    include $forthewin::spark::preinstall_class
    Class[$forthewin::spark::preinstall_class] -> Class['forthewin::spark::preinstall']
  }

  if ($facts[architecture] == 'x64') {
    $registry_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\3057-7228-2063-7466'
  } else {
    $registry_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\3057-7228-2063-7466'
  }
  $unless = "$forthewin::params::cmd /c reg query \"${registry_key}\" /f \"${forthewin::spark::version}\" /d /c /e"
  $command = "$forthewin::params::cmd /c taskkill /F /IM Spark.exe /T"

  if $forthewin::spark::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] command      = ${command}")
    info("[${trusted[certname]}] registry_key = ${registry_key}")
    info("[${trusted[certname]}] unless       = ${unless}")
  }

  exec { "Kill Spark before install/update":
    command => $command,
    returns => ['0', '128'],
    unless  => $unless
  }

}