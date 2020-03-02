# Manage Windows services
class forthewin::services (
  Boolean $started_services_enable = true,
  Boolean $stopped_services_enable = false,
  ) inherits forthewin::params {

  info("[${trusted[certname]}] PARAMETERS & VARIABLES:")
  info("[${trusted[certname]}] started_services_enable = ${started_services_enable}")
  info("[${trusted[certname]}] stopped_services_enable = ${stopped_services_enable}")

  $started_services = lookup('forthewin::services::started_services', Array[String], 'unique')
  $stopped_services = lookup('forthewin::services::stopped_services', Array[String], 'unique')

  info("[${trusted[certname]}] started_services        = ${started_services}")
  info("[${trusted[certname]}] stopped_services        = ${stopped_services}")

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