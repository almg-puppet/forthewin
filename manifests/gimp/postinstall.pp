class forthewin::gimp::postinstall {

  # Gimp uninstall options
  $uninstall_options = ["/S"]

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] uninstall_options = ${uninstall_options}")

  # Remove unwanted software
  unless (empty($forthewin::gimp::uninstall_list)) {
    package { $forthewin::gimp::uninstall_list:
      ensure            => absent,
      uninstall_options => $uninstall_options
    }
  }

}