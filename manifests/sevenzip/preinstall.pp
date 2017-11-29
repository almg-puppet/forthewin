class forthewin::sevenzip::preinstall {

  package { $forthewin::sevenzip::uninstall_list:
    ensure => absent
  }

}