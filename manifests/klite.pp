# Guidelines for unattended installation:
# http://www.codecguide.com/silentinstall.htm
#
# Installation FAQ:
# https://codecguide.com/faq_installation.htm
#
class forthewin::klite (
  Enum['Basic', 'Standard', 'Full', 'Mega'] $bundle = 'Standard',
  Array[String] $command_line_options = ['/verysilent', '/norestart', '/suppressmsgboxes'],
  Optional[String] $config_filename = undef,
  Optional[String] $config_path = undef,
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\klite",
  Boolean $unattended_installation = true,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] bundle                  = ${bundle}")
    info("[${trusted[certname]}] command_line_options    = ${command_line_options}")
    info("[${trusted[certname]}] config_filename         = ${config_filename}")
    info("[${trusted[certname]}] config_path             = ${config_path}")
    info("[${trusted[certname]}] installer_filename      = ${installer_filename}")
    info("[${trusted[certname]}] installer_path          = ${installer_path}")
    info("[${trusted[certname]}] unattended_installation = ${unattended_installation}")
    info("[${trusted[certname]}] verbose                 = ${verbose}")
    info("[${trusted[certname]}] version                 = ${version}")
  }

  # Full path to installer
  $v = split($version, '[.]')
  $plain_version = "${v[0]}${v[1]}${v[2]}"
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\K-Lite_Codec_Pack_${plain_version}_${bundle}.exe"
  }

  # Install options
  $config = sprintf('%s\\%s', $config_path ? { undef => $installer_path, default => $config_path },
                              $config_filename ? { undef => "klcp_${bundle.downcase}_unattended.ini", default => $config_filename })
  if $config =~ /^puppet:/ {
    $config_slashed = regsubst($config, '\\\\', '/', 'G')
  } else {
    $config_slashed = $config
  }
  $local_config = "${forthewin::params::tempdir}\\klite.ini"
  if $unattended_installation {
    $install_options = concat($command_line_options, ["/LoadInf=\"${local_config}\""])
    file { $local_config:
      before => Package['K-Lite Codec Pack'],
      source => $config_slashed
    }
  } else {
    $install_options = $command_line_options
  }

  # Package name
  $major_version = Integer($v[0])
  if $major_version < 12 {
    $klite = "K-Lite ${bundle} Codec Pack ${version}"
  } else {
    $klite = "K-Lite Codec Pack ${version} ${bundle}"
  }

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] config          = ${config}")
    info("[${trusted[certname]}] config_slashed  = ${config_slashed}")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer       = ${installer}")
    info("[${trusted[certname]}] klite           = ${klite}")
    info("[${trusted[certname]}] local_config    = ${local_config}")
    info("[${trusted[certname]}] major_version   = ${major_version}")
    info("[${trusted[certname]}] plain_version   = ${plain_version}")
    info("[${trusted[certname]}] v               = ${v}")
  }

  unless $forthewin::params::platform == 'wxp' {
    package { 'K-Lite Codec Pack':
      name            => $klite,
      ensure          => $version,
      source          => $installer,
      install_options => $install_options,
    }
  }

}