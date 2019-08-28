class forthewin::spark (
  Optional[String] $config_class = undef,
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\spark",
  Optional[String] $preinstall_class = undef,
  String $server = "openfire.${facts[domain]}",
  Optional[String] $startonstartup = undef,
  Boolean $verbose = $forthewin::params::verbose,
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  ) inherits forthewin::params {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] config_class       = ${config_class}")
    info("[${trusted[certname]}] installer_filename = ${installer_filename}")
    info("[${trusted[certname]}] installer_path     = ${installer_path}")
    info("[${trusted[certname]}] preinstall_class   = ${preinstall_class}")
    info("[${trusted[certname]}] server             = ${server}")
    info("[${trusted[certname]}] startonstartup     = ${startonstartup}")
    info("[${trusted[certname]}] verbose            = ${verbose}")
    info("[${trusted[certname]}] version            = ${version}")
  }

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::spark::preinstall
  contain forthewin::spark::install
  contain forthewin::spark::config

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::spark::preinstall'] -> Class['forthewin::spark::install'] -> Class['forthewin::spark::config']

}