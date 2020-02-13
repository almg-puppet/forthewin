class forthewin::essentials2012::install {

  # Full path to installer
  $installer = "${forthewin::essentials2012::installer_path}\\${forthewin::essentials2012::installer_filename}"

  # Install options of the resource package
  $common_install_options = ['/SILENT', '/QUIET', '/NoCEIP', '/NoToolbarCEIP', '/NoHomepage', '/NoLaunch', '/NoMU', '/NoSearch']

  unless $forthewin::essentials2012::install_all {

    # https://forge.puppet.com/puppetlabs/stdlib#join
    $appselect = join(delete(delete(delete(delete(delete(delete(['FamilySafety', 'Mail', 'Messenger', 'MovieMaker', 'WLSync', 'Writer']
                  , $forthewin::essentials2012::install_familysafety ? { true => '', false => 'FamilySafety' })
                  , $forthewin::essentials2012::install_mail         ? { true => '', false => 'Mail' })
                  , $forthewin::essentials2012::install_messenger    ? { true => '', false => 'Messenger' })
                  , $forthewin::essentials2012::install_moviemaker   ? { true => '', false => 'MovieMaker' })
                  , $forthewin::essentials2012::install_skydrive     ? { true => '', false => 'WLSync' })
                  , $forthewin::essentials2012::install_writer       ? { true => '', false => 'Writer' })
                  , ',')

    # https://docs.puppet.com/puppet/latest/lang_expressions.html#concatenation
    $install_options = $common_install_options + ["/AppSelect:${appselect}"]

  } else {

    $install_options = $common_install_options

  }

  info('VARIABLES:')
  info("appselect = ${appselect}")
  info("common_install_options = ${common_install_options}")
  info("installer = ${installer}")
  info("install_options = ${install_options}")

  # No Essentials 2012 for Windows XP and Windows Vista
  unless $forthewin::params::platform in ['wxp', 'wvista'] {
    package { 'Windows Essentials 2012':
      name            => 'Windows Live Essentials',
      ensure          => $forthewin::essentials2012::version,
      source          => $installer,
      install_options => $install_options,
    }
  }

}