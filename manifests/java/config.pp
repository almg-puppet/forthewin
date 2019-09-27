class forthewin::java::config {

  if $forthewin::java::disable_autoupdate and $forthewin::params::platform == 'wxp' {
    # On Windows XP, we need to execute a command to prevent Java from asking for updates.
    # Though not ideal, this might be useful in some scenarios.
    exec { "${forthewin::params::msiexec} /qn /x {4A03706F-666A-4037-7777-5F2748764D10}":
      returns => ['0', '1605'],
      onlyif  => "${forthewin::params::cmd} /c reg query HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{4A03706F-666A-4037-7777-5F2748764D10}"
    }
  }

  # Remove the Java Auto Updater package.
  if $forthewin::java::remove_auto_updater {
    package { 'Java Auto Updater':
      ensure => absent,
    }
  }

  # Remove unwanted software
  # https://forge.puppet.com/puppetlabs/stdlib#empty
  unless (empty($forthewin::java::uninstall_list)) {
    package { $forthewin::java::uninstall_list:
      ensure => absent,
    }
  }

  # Place the exception.sites file at the appropriate place.
  unless empty($forthewin::java::exceptions_list) {

    if $forthewin::params::platform == 'wxp' {
      $basedir = 'C:/Documents and Settings/Default User/Dados de aplicativos'
    } else {
      $basedir = 'C:/Users/Default/AppData/LocalLow'
    }

    if $forthewin::java::verbose {
      info("[${trusted[certname]}] VARIABLES:")
      info("[${trusted[certname]}] basedir = ${basedir}")
    }

    file { ["${basedir}/Sun", "${basedir}/Sun/Java", "${basedir}/Sun/Java/Deployment", "${basedir}/Sun/Java/Deployment/security"]:
        ensure => directory,
    }
    ->
    file { 'exception.sites':
      path               => "${basedir}/Sun/Java/Deployment/security/exception.sites",
      ensure             => file,
      content            => join($forthewin::java::exceptions_list, "\r\n"),
    }

  }

}

