class forthewin::essentials2012::preinstall {

  # Remove unwanted software
  # https://forge.puppet.com/puppetlabs/stdlib#empty
  unless (empty($forthewin::essentials2012::uninstall_list)) {
    package { $forthewin::essentials2012::uninstall_list:
      ensure => absent,
    }
  }

}