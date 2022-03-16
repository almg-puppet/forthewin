class forthewin::thunderbird::preinstall {

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