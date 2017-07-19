# Manage Windows services 
class forthewin::services (
  Enum['true', 'false'] $started_services_enable = 'true',
  Enum['true', 'false'] $stopped_services_enable = 'false',


  ) inherits forthewin::params {

  $started_services = hiera_array('forthewin::services::started_services')
  $stopped_services = hiera_array('forthewin::services::stopped_services')

  
  info('PARAMETERS:')
  info("started_services_enable = ${started_services_enable}")
  info("started_services = ${started_services}")
  info("stopped_services_enable = ${stopped_services_enable}")
  info("stopped_services = ${stopped_services}")


  unless $forthewin::params::platform == 'wxp' {
	if ! empty($started_services) {
		$started_services.each |$service| { 
			service { "$service":
				ensure => "running",
				enable => $started_services_enable
			}
		}
	}

	if ! empty($stopped_services) {
		$stopped_services.each |$service| { 
			service { "$service":
				ensure => "stopped",
				enable => $stopped_services_enable
			}
		}
	}

	
}
}
