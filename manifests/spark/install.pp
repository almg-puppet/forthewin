class forthewin::spark::install {

  # Full path to installer
  if $forthewin::spark::installer_filename {
    $installer = "${forthewin::spark::installer_path}\\${forthewin::spark::installer_filename}"
  } else {
    # Name convention is the same of http://www.igniterealtime.org/downloads/
    $v = split($forthewin::spark::version, '[.]')
    $installer = "${forthewin::spark::installer_path}\\spark_${v[0]}_${v[1]}_${v[2]}.exe"
  }

  if $forthewin::spark::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer       = ${installer}")
    info("[${trusted[certname]}] v               = ${v}")
  }

  package { 'Spark':
    name            => "Spark ${forthewin::spark::version}",
    ensure          => $forthewin::spark::version,
    source          => $installer,
    install_options => ['-q'],
  }

}