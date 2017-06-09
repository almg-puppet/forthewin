# This goes in the onlyif clausule of the exec resource
if ( Get-WmiObject -Class Win32_Product -Filter "Name like 'Adobe Shockwave%'" ) {
  # exec needs to run in order to remove the installed MSI
  $returncode = 0
} else {
  # nothing to do
  $returncode = 1
}
exit $returncode