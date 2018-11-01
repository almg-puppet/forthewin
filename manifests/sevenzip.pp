# http://www.7-zip.org/download.html
class forthewin::sevenzip (
  Array[String] $assoc = ['001', '7z', 'arj', 'bz2', 'bzip2', 'cab', 'cpio', 'deb', 'dmg', 'fat', 'gz', 'gzip', 'hfs', 'iso', 'lha', 'lzh', 'lzma', 'ntfs', 'rar', 'rpm', 'squashfs', 'swm', 'tar', 'taz', 'tbz', 'tbz2', 'tgz', 'tpz', 'txz', 'vhd', 'wim', 'xar', 'xz', 'z', 'zip'],
  Optional[Enum['x86', 'x64']] $installer_arch = undef,
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\7zip",
  Array[String] $uninstall_list = [],
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+\Z/] $version,
  Boolean $x86_only = false,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] assoc              = ${assoc}")
    info("[${trusted[certname]}] installer_arch     = ${installer_arch}")
    info("[${trusted[certname]}] installer_filename = ${installer_filename}")
    info("[${trusted[certname]}] installer_path     = ${installer_path}")
    info("[${trusted[certname]}] uninstall_list     = ${uninstall_list}")
    info("[${trusted[certname]}] version            = ${version}")
    info("[${trusted[certname]}] x86_only           = ${x86_only}")
  }

  # Proceed if installer_filename XNOR installer_arch
  unless (!$installer_filename and !$installer_arch) or ($installer_filename and $installer_arch) {
    fail("[${trusted[certname]}] Either provide none or both values for parameters 'installer_arch' and 'installer_filename'.")
  }

  contain forthewin::sevenzip::install

  # Remove unwanted software
  unless empty($uninstall_list) {
    contain forthewin::sevenzip::preinstall
    Class['forthewin::sevenzip::preinstall'] -> Class['forthewin::sevenzip::install']
  }

  # Associate file extensions with 7-Zip Manager
  unless empty($assoc) or $forthewin::params::platform in ['wxp', 'wvista'] {
    contain forthewin::sevenzip::config
    Class['forthewin::sevenzip::install'] -> Class['forthewin::sevenzip::config']
  }

}
