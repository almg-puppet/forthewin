class forthewin::firefox_esr::config {

  # Full path to Firefox's customized settings, source and destination
  if $forthewin::firefox_esr::config_path {
    $policies_src = "${forthewin::firefox_esr::config_path}\\${forthewin::firefox_esr::config_filename}"
  } else {
    $policies_src = "${forthewin::firefox_esr::installer_path}\\${forthewin::firefox_esr::version}\\${forthewin::firefox_esr::config_filename}"
  }

  if $policies_src =~ /^puppet:/ {
    $policies_src_slashed = regsubst($policies_src, '\\\\', '/', 'G')
  } else {
    $policies_src_slashed = $policies_src
  }

  $policies_home = "${forthewin::firefox_esr::firefox_home}\\distribution"
  $policies_dst = "${policies_home}\\policies.json"

  if $forthewin::firefox_esr::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] policies_dst         = ${policies_dst}")
    info("[${trusted[certname]}] policies_home        = ${policies_home}")
    info("[${trusted[certname]}] policies_src         = ${policies_src}")
    info("[${trusted[certname]}] policies_src_slashed = ${policies_src_slashed}")
  }

  # Creates policies.json
  # https://github.com/mozilla/policy-templates
  file { $policies_home:
    ensure => directory
  }
  ->
  file { $policies_dst:
    ensure => file,
    source => $policies_src_slashed
  }

  # Enable/Disable Crash Reporter
  # https://firefox-source-docs.mozilla.org/toolkit/crashreporter/crashreporter/index.html
  if $forthewin::firefox_esr::crashreporter_disable {
    windows_env { 'MOZ_CRASHREPORTER_DISABLE=1':
      mergemode => clobber
    }
  } else {
    windows_env { 'MOZ_CRASHREPORTER_DISABLE':
      ensure    => absent,
      mergemode => clobber,
    }
  }

}
