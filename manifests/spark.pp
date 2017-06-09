class forthewin::spark (
  Optional[String] $installer_filename = undef,
  String $installer_path = "${forthewin::params::repo_basepath}\\spark",
  Array[String] $uninstall_list = [],
  String $server = "openfire.${facts[domain]}",
  Pattern[/\A[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+\Z/] $version,
  ) inherits forthewin::params {

  info('PARAMETERS:')
  info("installer_filename = ${installer_filename}")
  info("installer_path = ${installer_path}")
  info("uninstall_list = ${uninstall_list}")
  info("server = ${server}")
  info("version = ${version}")

  # https://docs.puppet.com/puppet/latest/lang_containment.html
  contain forthewin::spark::preinstall
  contain forthewin::spark::install
  contain forthewin::spark::config

  # https://docs.puppet.com/puppet/latest/lang_relationships.html
  Class['forthewin::spark::preinstall'] -> Class['forthewin::spark::install'] -> Class['forthewin::spark::config']

}