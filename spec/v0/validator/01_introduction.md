# Validator

The Validator class models the strict, or _canonical_, specification of the `.ruby`
file. It is used internally to validate the a `.ruby` file as it is loaded into
the Specification class.

NOTE: This set of tests includes the `DotRuby::V0` module into the testing
namespace to simplify testing to revision 0 of DotRuby.
