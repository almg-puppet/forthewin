# http://www.videolan.org/vlc/
# https://wiki.videolan.org/Documentation:Installing_VLC/
# Locale Codes (needs conversion to decimal):
# https://msdn.microsoft.com/pt-br/library/windows/desktop/dd318693%28v=vs.85%29.aspx
class forthewin::vlc (
  Enum['win32', 'win64'] $arch = 'win32',
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\vlc",
  Integer $locale_code = 1033,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("arch = ${arch}")
  info("installer_filename = ${installer_filename}")
  info("locale_code = ${locale_code}")
  info("installer_path = ${installer_path}")
  info("version = ${version}")

  # Display name
  # Note the implicit String to Integer conversion bellow (0 + String).
  # https://docs.puppet.com/puppet/latest/lang_data_number.html#converting-strings-to-numbers
  $v = split($version, '[.]')
  if ($v[0] == '2' and (0 +$v[1]) >= 2) {
    $displayname = 'VLC media player'
  } else {
    $displayname = "VLC media player ${version}"
  }

  # Full path to VLC's installer
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\vlc-${version}-${arch}.exe"
  }

  # Install options of the resource package
  $install_options = ["/L=${locale_code}", '/S']

  info('VARIABLES:')
  info("v = ${v}")
  info("displayname = ${displayname}")
  info("installer = ${installer}")
  info("install_options = ${install_options}")

  package { 'VLC media player':
    name            => $displayname,
    ensure          => $version,
    source          => $installer,
    install_options => $install_options,
  }

}