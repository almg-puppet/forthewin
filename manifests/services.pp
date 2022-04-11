# Manage Windows services
class forthewin::services (
  Boolean $started_services_enable = true,
  Boolean $stopped_services_enable = false,
  Boolean $verbose = $forthewin::params::verbose,
  ) inherits forthewin::params {

  $started_services = lookup('forthewin::services::started_services', Array[String], 'unique')
  $stopped_services = lookup('forthewin::services::stopped_services', Array[String], 'unique')

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] started_services_enable = ${started_services_enable}")
    info("[${trusted[certname]}] stopped_services_enable = ${stopped_services_enable}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] started_services        = ${started_services}")
    info("[${trusted[certname]}] stopped_services        = ${stopped_services}")
  }

	unless empty($started_services) {
    service { $started_services:
      ensure => running,
      enable => $started_services_enable
    }
	}

	unless empty($stopped_services) {
    service { $stopped_services:
      ensure => stopped,
      enable => $stopped_services_enable
    }
  }

}