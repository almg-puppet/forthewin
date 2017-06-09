class forthewin::firefox::preinstall {

  unless empty($forthewin::firefox::installer_args) {
    info("[${trusted[certname]}] Will create ${forthewin::firefox::config_ini}")
    file { $forthewin::firefox::config_ini:
      ensure  => file,
      content => sprintf("; ${forthewin::params::default_header}[Install]\r\n%s", join($forthewin::firefox::installer_args, "\r\n")),
    }
  }

  if $forthewin::firefox::uninstall_maintenance_service {
    info("[${trusted[certname]}] Will uninstall Mozilla Maintenance Service")
    package { 'Mozilla Maintenance Service':
      ensure            => absent,
      uninstall_options => ['/S'],
    }
  }

}