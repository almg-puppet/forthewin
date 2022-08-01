# Eclipse Temurin JDK: Install Eclipse JDK.
#  Installer downloaded from: https://adoptium.net/
#
#
class forthewin::eclipse_jdk (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\eclipse_jdk",
  Enum['auto', 'x86', 'x64'] $installer_arch = 'auto',
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version
  ) inherits forthewin::params {

    # Determines installer architecture
    if $installer_arch == 'auto' {
      $package_arch = $facts[architecture] ? {'x86' => 'x86', default => 'x64'}
    } else {
      $package_arch = $installer_arch
    }



  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] installer_filename      = ${installer_filename}")
    info("[${trusted[certname]}] installer_path          = ${installer_path}")
	info("[${trusted[certname]}] installer_arch          = ${installer_arch}")
    info("[${trusted[certname]}] verbose                 = ${verbose}")
    info("[${trusted[certname]}] version                 = ${version}")
  }


  # Full path to installer

  $v = split($version, '[.]')
  $package_version = "${v[0]}.${v[1]}.${v[2]}+${v[3]} (${package_arch})"
  $major_version = "${v[0]}"
  $build = "${v[3]}"
  
  if $installer_filename {
    $installer = "${installer_path}\\${installer_filename}"
  } else {
    $installer = "${installer_path}\\OpenJDK${major_version}U-jdk_${package_arch}_windows_hotspot_${v[0]}.${v[1]}.${v[2]}_${v[3]}.msi"
  }

  # Install options
  $install_options = ["/qn" , "ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome,FeatureOracleJavaSoft"]

  $package_name = "Eclipse Temurin JDK with Hotspot ${package_version}"


  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] config          = ${config}")
    info("[${trusted[certname]}] install_options = ${install_options}")
    info("[${trusted[certname]}] installer       = ${installer}")
    info("[${trusted[certname]}] package_name    = ${package_name}")
       
  }

    package { 'Eclipse JDK':
      name            => $package_name,
      ensure          => $version,
      source          => $installer,
      install_options => $install_options,
    } 

}
