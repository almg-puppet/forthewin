# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
# ============================================================================
#
# There is no default value for the parameter "version". It should be set either explicitly, using resource-like declaration, or in Hiera.
# To use the idempotent form "include forthewin::essentials", you must use Hiera.
#
# Please refer to documentation for more information regarding the class and its parameters.
# For example, it is very likely that you will need to override the default value for the "installer_path" parameter.
#
class {'forthewin::essentials' : version => '16.4.3528.0331'}
