# In order to support puppet 3.8.x the following legacy facts were used instead of the new ones:
# networking[domain] => domain
# os[family] => osfamily
#
# That's because 3.8.x does not support structured facts - it has access only to the first level.
#
# To support the more readable and maintainable syntax $facts[fact], you must enable
# "future=parse" and "trusted_node_data=true". References:
#
# https://docs.puppet.com/puppet/3.8/lang_facts_and_builtin_vars.html#the-factsfactname-hash
# https://docs.puppet.com/puppet/3.8/config_important_settings.html#recommended-and-safe
# https://docs.puppet.com/puppet/3.8/experiments_future.html#enabling-the-future-parser
class forthewin::params (
  Pattern[/\A[a-z]{2,3}(?:-[A-Z]{2})?\Z/] $lang = 'en-US',
  String $repo_basepath = "\\\\winrepo.${facts[domain]}",
  String $tempdir = $winparams::tempdir,
  Boolean $verbose = $winparams::verbose,
  ) inherits winparams {

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] lang           = ${lang}")
    info("[${trusted[certname]}] repo_basepath  = ${repo_basepath}")
    info("[${trusted[certname]}] tempdir        = ${tempdir}")
  }

  if $facts[osfamily] != 'windows' {
    fail('Unsupported platform. This module is Windows only.')
  }

  # The following text is inserted as comments in the begining of all config files defined in this module
  $default_header = "Generated automatically by almg-${module_name} puppet module.\r\n"

  if $verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] default_header = ${default_header}")
  }  
  
  # Resource defaults
  File {
    # In 3.x source_permissions defaults to "use" while in 4.x it defaults to "ignore"
    source_permissions => 'ignore'
  }

}