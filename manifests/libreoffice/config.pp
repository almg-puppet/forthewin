# https://wiki.documentfoundation.org/Deployment_and_Migration
class forthewin::libreoffice::config {

  $basereg = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\LibreOffice'
  $common  = "${basereg}\\org.openoffice.Office.Common"

  info("[${trusted[certname]}] VARIABLES:")
  info("[${trusted[certname]}] basereg = ${basereg}")
  info("[${trusted[certname]}] common  = ${common}")

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

}