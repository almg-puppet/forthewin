class forthewin::spark::config {

  $config_dir	= "${forthewin::params::userprofile}\\Spark"
	$config_file   = "${config_dir}\\spark.properties"
  $logged_user = $facts[username]

  info('VARIABLES:')
  info("config_dir = ${config_dir}")
  info("config_file = ${config_file}")
  info("logged_user = ${logged_user}")

  unless $logged_user == 'unknown' {

    file { "$config_dir" :
      ensure => directory,
    }
    ->
    file { "$config_file" :
      ensure => file,
    }
    ->
    file_line { 'spark.properties.server':
      ensure => present,
      line   => "server=${forthewin::spark::server}",
      match  => '^server\=',
      path   => $config_file,
      replace => true,
    }

  }
}