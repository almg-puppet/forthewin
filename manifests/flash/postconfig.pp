class forthewin::flash::postconfig {

  $stick_settings = {
    'AutoUpdateDisable' => $forthewin::flash::disable_autoupdate ? { true => '1', false => '0' },
    'SilentAutoUpdateEnable' => $forthewin::flash::enable_silent_autoupdate ? { true => '1', false => '0' },
  }
  $settings = { '' => merge($forthewin::flash::settings, $stick_settings) }

  $inifile_defaults = {
    'ensure' => 'present',
    'path' => $forthewin::flash::mmscfg_path,
  }

  if $forthewin::flash::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] inifile_defaults = ${inifile_defaults}")
    info("[${trusted[certname]}] settings         = ${settings}")
    info("[${trusted[certname]}] stick_settings   = ${stick_settings}")
  }

  create_ini_settings($settings, $inifile_defaults)

}