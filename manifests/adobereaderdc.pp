# Patches and installation sources: https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html
class forthewin::adobereaderdc (
  Optional[String] $base_filename = undef,
  String $base_version = '15.007.20033',
  String $installer_path = "${forthewin::params::repo_basepath}\\adobe",
  String $lang = 'pt_BR',
  Optional[String] $update_filename = undef,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+\Z/] $update_version,
  Boolean $verbose = $forthewin::params::verbose,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] base_filename   = ${base_filename}")
    info("[${trusted[certname]}] base_version    = ${base_version}")
    info("[${trusted[certname]}] installer_path  = ${installer_path}")
    info("[${trusted[certname]}] lang            = ${lang}")
    info("[${trusted[certname]}] update_filename = ${update_filename}")
    info("[${trusted[certname]}] update_version  = ${update_version}")
  }

  # Version parsing
  $product = split($base_version, '[.]')[0] ? {'15' => 'DC', default => fail('Unsupported product! Check [base_version].')}
  $flat_base_version = join(split($base_version, '[.]'), '')
  $flat_update_version = join(split($update_version, '[.]'), '')

	# Set varibles based on existing facts
  $is_adobereaderdc_installed = $facts[is_adobereaderdc_installed]
  $adobereaderdc_version = $facts[adobereaderdc_version]

  # Set base installer path
  if $base_filename {
    $base_installer = "${installer_path}\\${base_filename}"
  } else {
    $base_installer = "${installer_path}\\AcroRdrDC${flat_base_version}_${lang}.exe"
  }

  # Set update installer path
  if $update_filename {
    $update_installer = "${installer_path}\\${update_filename}"
  } else {
    $update_installer = "${installer_path}\\AcroRdrDCUpd${flat_update_version}.msp"
  }

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] is_adobereaderdc_installed = ${is_adobereaderdc_installed}")
    info("[${trusted[certname]}] adobereaderdc_version      = ${adobereaderdc_version}")
    info("[${trusted[certname]}] flat_base_version          = ${flat_base_version}")
    info("[${trusted[certname]}] base_installer             = ${base_installer}")
    info("[${trusted[certname]}] flat_update_version        = ${flat_update_version}")
    info("[${trusted[certname]}] update_installer           = ${update_installer}")
    info("[${trusted[certname]}] product                    = ${product}")
  }

  if $is_adobereaderdc_installed {

    if $update_version > $adobereaderdc_version {

      $exec_title = "Adobe Reader ${product} ${update_version}"
      $exec_command = "C:\\Windows\\System32\\msiexec.exe /update ${update_installer} /qn"

      if $verbose {
        info("[${trusted[certname]}] exec_title   = ${exec_title}")
        info("[${trusted[certname]}] exec_command = ${exec_command}")
      }

      exec { $exec_title:
        command => $exec_command,
      }

    }

  } else {

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