class forthewin::firefox_esr::config {

  # Full path to Firefox's customized settings, source and destination
  if $forthewin::firefox_esr::config_path {
    $policies_src = "${forthewin::firefox_esr::config_path}\\${forthewin::firefox_esr::config_filename}"
  } else {
    $policies_src = "${forthewin::firefox_esr::installer_path}\\${forthewin::firefox_esr::version}\\${forthewin::firefox_esr::config_filename}"
  }
  $policies_home = "${forthewin::firefox_esr::firefox_home}\\distribution"
  $policies_dst = "${policies_home}\\policies.json"
  

  if $forthewin::firefox_esr::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] policies_dst  = ${policies_dst}")
    info("[${trusted[certname]}] policies_home = ${policies_home}")
    info("[${trusted[certname]}] policies_src  = ${policies_src}")
  }

  file { $policies_home:
    ensure => directory
  }
  ->
  file { $policies_dst:
    ensure => file,
    source => $policies_src
  }

}
