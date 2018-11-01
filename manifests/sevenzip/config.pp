class forthewin::sevenzip::config {

  # File icons to be used in file association with 7-Zip
  $icons = {
    '001'      => 9,
    '7z'       => 0,
    'arj'      => 4,
    'bz2'      => 2,
    'bzip2'    => 2,
    'cab'      => 7,
    'cpio'     => 12,
    'deb'      => 11,
    'dmg'      => 17,
    'fat'      => 21,
    'gz'       => 14,
    'gzip'     => 14,
    'hfs'      => 18,
    'iso'      => 8,
    'lha'      => 6,
    'lzh'      => 6,
    'lzma'     => 16,
    'ntfs'     => 22,
    'rar'      => 3,
    'rpm'      => 10,
    'squashfs' => 24,
    'swm'      => 15,
    'tar'      => 13,
    'taz'      => 5,
    'tbz'      => 2,
    'tbz2'     => 2,
    'tgz'      => 14,
    'tpz'      => 14,
    'txz'      => 23,
    'vhd'      => 20,
    'wim'      => 15,
    'xar'      => 19,
    'xz'       => 23,
    'z'        => 5,
    'zip'      => 1,
  }

  # Which "program files" to use?
  case $forthewin::sevenzip::install::installer {
    $forthewin::sevenzip::install::installer_x86: { $programfiles = $forthewin::params::programfiles32 }
    $forthewin::sevenzip::install::installer_x64: { $programfiles = $forthewin::params::programfiles }
    default: {
      if $forthewin::sevenzip::installer_arch == 'x86' {
        $programfiles = $forthewin::params::programfiles32
      } else {
        $programfiles = $forthewin::params::programfiles
      }
    }
  }

  if $forthewin::sevenzip::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] icons = ${icons}")
    info("[${trusted[certname]}] programfiles = ${programfiles}")
  }

  $forthewin::sevenzip::assoc.each | $ext | {

    registry::value { ".${ext}":
      key   => "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\.${ext}",
      value => '(default)',
      data  => "7-Zip.${ext}",
    }

    registry::value { "7-Zip.${ext}":
      key   => "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\7-Zip.${ext}",
      value => '(default)',
      data  => "${ext} Archive",
    }

    registry::value { "7-Zip.${ext}\\DefaultIcon":
      key   => "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\7-Zip.${ext}\\DefaultIcon",
      value => '(default)',
      data  => "${programfiles}\\7-Zip\\7z.dll,${icons[$ext]}",
    }

    registry::value { "7-Zip.${ext}\\shell\\open\\command":
      key   => "HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\7-Zip.${ext}\\shell\\open\\command",
      value => '(default)',
      data  => "\"${programfiles}\\7-Zip\\7zFM.exe\" \"%1\"",
    }

  }

}
