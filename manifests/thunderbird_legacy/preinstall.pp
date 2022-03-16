class forthewin::thunderbird_legacy::preinstall {

  unless empty($forthewin::thunderbird_legacy::installer_args) {
    if $forthewin::thunderbird_legacy::verbose {
      info("[${trusted[certname]}] Will create ${forthewin::thunderbird_legacy::config_ini}")
    }
    file { $forthewin::thunderbird_legacy::config_ini:
      ensure  => file,
      content => sprintf("; ${forthewin::params::default_header}[Install]\r\n%s", join($forthewin::thunderbird_legacy::installer_args, "\r\n")),
    }
  }

  if $forthewin::thunderbird_legacy::uninstall_maintenance_service {
    if $forthewin::thunderbird_legacy::verbose {
      info("[${trusted[certname]}] Will uninstall Mozilla Maintenance Service")
    }
    package { 'Mozilla Maintenance Service':
      ensure            => absent,
      uninstall_options => ['/S'],
    }
  }

}