class forthewin::adobereader::install {

  # Version parsing
  $fullversion = $forthewin::adobereader::version
  $managed_version = $forthewin::adobereader::managed_version

  if $forthewin::adobereader::installer_filename {
    $installer = "${forthewin::adobereader::installer_path}\\${forthewin::adobereader::installer_filename}"
  } else {
	if ($forthewin::adobereader::managed_version == 'DC') {
		$installer = "${forthewin::adobereader::installer_path}\\AcroRdrDC1500720033_pt_BR.exe"
	} else {
		$installer = "${forthewin::adobereader::installer_path}\\AdbeRdr11000_pt_BR.exe"
	}
  }

	# Set varibles based on existing facts
    $is_adobereaderdc_installed = $facts[is_adobereaderdc_installed]
    $is_adobereaderxi_installed = $facts[is_adobereaderxi_installed]


  if $forthewin::adobereader::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] installer		   = ${installer}")
    info("[${trusted[certname]}] managed_version   = ${managed_version}")
    info("[${trusted[certname]}] Version           = ${fullversion}")
	info("[${trusted[certname]}] is_adobereaderdc_installed           = ${is_adobereaderdc_installed}")
	info("[${trusted[certname]}] is_adobereaderxi_installed           = ${is_adobereaderxi_installed}")
  }

  if ((($is_adobereaderdc_installed) and ($managed_version == 'DC')) or (($is_adobereaderxi_installed) and ($managed_version == 'XI'))) {
 	$package_name = "Adobe Reader ${managed_version} (${fullversion})"
	$source_file = "${forthewin::adobereader::installer_path}\\${forthewin::adobereader::installer_update_filename}"
	$cmd_line = "c:\\Windows\\System32\\msiexec.exe /update ${source_file} /qn"

	
	if ($managed_version == 'XI') {
		# using join to concat cmd string due to the usage of double quotes (") inside the command.
		$cmd_unless = join(['c:\Windows\System32\cmd.exe /c c:\Windows\System32\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\68AB67CA7DA76401B744BA0000000010\InstallProperties" /v DisplayVersion |c:\Windows\System32\findstr.exe ', $fullversion])
	} else {
		# using join to concat cmd string due to the usage of double quotes (") inside the command.
		$cmd_unless = join(['c:\Windows\System32\cmd.exe /c c:\Windows\System32\reg.exe query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\68AB67CA7DA76401B744CAF070E41400\InstallProperties" /v DisplayVersion |c:\Windows\System32\findstr.exe ', $fullversion])
	}	
	exec { $package_name:
		command => $cmd_line,
		unless => $cmd_unless
	}
  }
  # Reader DC is more recent then XI so if DC is installed and managed_version is XI, instalation will be ignored.
  if (((!$is_adobereaderxi_installed) and ($managed_version == 'XI') and (!$is_adobereaderdc_installed)) or ((!$is_adobereaderdc_installed) and ($managed_version == 'DC'))) {
	$package_name = "Adobe Reader ${managed_version} - Português"
	$ensure_version = "present"
	$install_options = ['/sAll']
	$uninstall_options = ['/sAll']
	$source_file = $installer
	
	package { $package_name:
		name => $package_name,
		ensure => $ensure_version,
		source => $source_file,
		install_options => $install_options,
		uninstall_options => $uninstall_options,
	}
  }
}