class forthewin::spark (
  Optional[String] $custom_class = undef,
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
    info("[${trusted[certname]}] custom_class       = ${custom_class}")
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

  # If you want to customize anything, implement it in a class and use the
  # parameter "custom_class" for invocation. Be sure to control, inside this
  # class, the precedence of execution. For example:
  # Class['forthewin::spark::config'] -> Class['custom::spark']
  # or
  # Class['custom::spark'] -> Class['forthewin::spark::config']
  unless empty($custom_class) {
    if $verbose {
      warning("[${trusted[certname]}] Invoking class ${custom_class}")
    }
    contain $custom_class
  }

}