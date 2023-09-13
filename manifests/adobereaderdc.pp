# Patches and installation sources: https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html
class forthewin::adobereaderdc (
  Optional[String] $acrobat_update_filename = undef,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $acrobat_update_version,
  Optional[String] $base_filename = undef,
  String $base_version = '15.007.20033',
  String $installer_path = "${forthewin::params::repo_basepath}\\adobe",
  String $lang = 'pt_BR',
  Optional[String] $reader_update_filename = undef,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $reader_update_version,
  Boolean $verbose = $forthewin::params::verbose,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] acrobat_update_filename = ${acrobat_update_filename}")
    info("[${trusted[certname]}] acrobat_update_version  = ${acrobat_update_version}")
    info("[${trusted[certname]}] base_filename           = ${base_filename}")
    info("[${trusted[certname]}] base_version            = ${base_version}")
    info("[${trusted[certname]}] installer_path          = ${installer_path}")
    info("[${trusted[certname]}] lang                    = ${lang}")
    info("[${trusted[certname]}] reader_update_filename  = ${reader_update_filename}")
    info("[${trusted[certname]}] reader_update_version   = ${reader_update_version}")
  }

  # Version parsing
  $product = split($base_version, '[.]')[0] ? {'15' => 'DC', default => fail('Unsupported product! Check [base_version].')}
  $flat_base_version = join(split($base_version, '[.]'), '')
  $acrobat_flat_update_version = join(split($acrobat_update_version, '[.]'), '')
  $reader_flat_update_version = join(split($reader_update_version, '[.]'), '')

	# Set varibles based on existing facts
  $is_adobereaderdc_installed = $facts[is_adobereaderdc_installed]
  $is_adobeacrobatdc_installed = $facts[is_adobeacrobatdc_installed]
  $adobereaderdc_version = $facts[adobereaderdc_version]
  $adobeacrobatdc_version = $facts[adobeacrobatdc_version]

  # Set base installer path
  if $base_filename {
    $base_installer = "${installer_path}\\${base_filename}"
  } else {
    $base_installer = "${installer_path}\\AcroRdrDC${flat_base_version}_${lang}.exe"
  }

  # Set update installer path for ACROBAT
  if $acrobat_update_filename {
    $acrobat_update_installer = "${installer_path}\\${acrobat_update_filename}"
  } else {
    $acrobat_update_installer = "${installer_path}\\AcrobatDCx64Upd${acrobat_flat_update_version}.msp"
  }

  # Set update installer path for READER
  if $reader_update_filename {
    $reader_update_installer = "${installer_path}\\${reader_update_filename}"
  } else {
    $reader_update_installer = "${installer_path}\\AcroRdrDCUpd${reader_flat_update_version}.msp"
  }

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] acrobat_flat_update_version = ${acrobat_flat_update_version}")
    info("[${trusted[certname]}] acrobat_update_installer    = ${acrobat_update_installer}")
    info("[${trusted[certname]}] adobeacrobatdc_version      = ${adobeacrobatdc_version}")
    info("[${trusted[certname]}] adobereaderdc_version       = ${adobereaderdc_version}")
    info("[${trusted[certname]}] base_installer              = ${base_installer}")
    info("[${trusted[certname]}] is_adobeacrobatdc_installed = ${is_adobeacrobatdc_installed}")
    info("[${trusted[certname]}] is_adobereaderdc_installed  = ${is_adobereaderdc_installed}")
    info("[${trusted[certname]}] flat_base_version           = ${flat_base_version}")
    info("[${trusted[certname]}] product                     = ${product}")
    info("[${trusted[certname]}] reader_flat_update_version  = ${reader_flat_update_version}")
    info("[${trusted[certname]}] reader_update_installer     = ${reader_update_installer}")
  }

  if $is_adobeacrobatdc_installed {

    # https://www.puppet.com/docs/puppet/5.5/function#versioncmp
    # versioncmp(a, b) returns
    #   1 if version a is greater than version b
    #   0 if the versions are equal
    #   -1 if version a is less than version b

    # Update ACROBAT only if newer than current version
    if versioncmp($acrobat_update_version, $adobeacrobatdc_version) == 1 {

      $acrobat_exec_title = "Adobe Acrobat ${acrobat_update_version}"
      $acrobat_exec_command = "C:\\Windows\\System32\\msiexec.exe /update ${acrobat_update_installer} /qn"

      if $verbose {
        info("[${trusted[certname]}] acrobat_exec_title   = ${acrobat_exec_title}")
        info("[${trusted[certname]}] acrobat_exec_command = ${acrobat_exec_command}")
      }

      exec { $acrobat_exec_title:
        command => $acrobat_exec_command
      }

    }

  } elsif $is_adobereaderdc_installed {

    # Update READER only if newer than current version
    if versioncmp($reader_update_version, $adobereaderdc_version) == 1 {

      $reader_exec_title = "Adobe Reader ${reader_update_version}"
      $reader_exec_command = "C:\\Windows\\System32\\msiexec.exe /update ${reader_update_installer} /qn"

      if $verbose {
        info("[${trusted[certname]}] reader_exec_title   = ${reader_exec_title}")
        info("[${trusted[certname]}] reader_exec_command = ${reader_exec_command}")
      }

      exec { $reader_exec_title:
        command => $reader_exec_command
      }
    }

  } else {
    # Nothing installed - installl base version

    $language = $lang ? {'pt_BR' => ' - Português', default => ''}
    $package_title = "Adobe Reader ${product} ${base_version}"
    $package_name = "Adobe Reader ${product}${language}"

    if $verbose {
      info("[${trusted[certname]}] language      = ${language}")
      info("[${trusted[certname]}] package_title = ${package_title}")
      info("[${trusted[certname]}] package_name  = ${package_name}")
    }

    package { $package_title:
      name            => $package_name,
      ensure          => present,
      source          => $base_installer,
      install_options => ['/sAll']
    }

  }

}