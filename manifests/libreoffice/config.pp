# https://wiki.documentfoundation.org/Deployment_and_Migration
class forthewin::libreoffice::config {

  $basereg = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\LibreOffice'
  $canvas  = "${basereg}\\org.openoffice.Office.Canvas"
  $common  = "${basereg}\\org.openoffice.Office.Common"

  if $forthewin::libreoffice::verbose {
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] basereg = ${basereg}")
    info("[${trusted[certname]}] canvas  = ${canvas}")
    info("[${trusted[certname]}] common  = ${common}")
  }

  if $forthewin::libreoffice::disable_opengl {

    registry::value { "UseOpenGL":
      key   => "${common}\\VCL\\UseOpenGL",
      value => 'Value',
      data  => 'false',
      type  => 'string',
    }

    registry::value { "ForceOpenGL":
      key   => "${common}\\VCL\\ForceOpenGL",
      value => 'Value',
      data  => 'false',
      type  => 'string',
    }

  }

  if $forthewin::libreoffice::disable_hw_graphic_accel {

    registry::value { "ForceSafeServiceImpl":
      key   => "${canvas}\\ForceSafeServiceImpl",
      value => 'Value',
      data  => 'true',
      type  => 'string',
    }

  }

}