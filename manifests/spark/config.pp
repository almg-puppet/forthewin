class forthewin::spark::config {

  # If you want to config anything else than property "spark.properties.server",
  # you can implement it in a class and use parameter "config_class" for invocation.
  unless  empty($forthewin::spark::config_class) {
    warning("[${trusted[certname]}] Invoking class ${forthewin::spark::config_class}")
    include $forthewin::spark::config_class
    Class[$forthewin::spark::config_class] -> Class['forthewin::spark::config']
  }

  $config_dir  = "${forthewin::params::userprofile}\\Spark"
  $config_file = "${config_dir}\\spark.properties"
  $logged_user = $facts[username]

  if $forthewin::spark::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] config_dir  = ${config_dir}")
    info("[${trusted[certname]}] config_file = ${config_file}")
    info("[${trusted[certname]}] logged_user = ${logged_user}")
  }

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
      ensure  => present,
      line    => "server=${forthewin::spark::server}",
      match   => '^server\=',
      path    => $config_file,
      replace => true,
    }

    if ($forthewin::spark::startonstartup) {
        file_line { 'spark.properties.startonstartup':
            ensure  => present,
            line    => "startOnStartup=${forthewin::spark::startonstartup}",
            match   => '^startOnStartup\=',
            path    => $config_file,
            replace => true,
        }
    }

  }

}
