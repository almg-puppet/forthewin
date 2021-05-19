class forthewin::adobereader::config {
# Disables update task to prevent software from updating automatically
# About this resource: https://puppet.com/docs/puppet/5.5/types/scheduled_task.html#scheduled_task-attribute-trigger
# Examples: https://forge.puppet.com/modules/puppetlabs/scheduled_task

  scheduled_task { "Adobe Acrobat Update Task":
      enabled => false,
      command => "C:\\Program Files (x86)\\Common Files\\Adobe\\ARM\\1.0\\AdobeARM.exe",
      trigger => [{
        schedule   => 'daily',
        start_time => '13:00',
      }]
  }

}