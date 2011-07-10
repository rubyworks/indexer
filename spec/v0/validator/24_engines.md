# Validator#engines

The `engines` field holds the RUBY_ENGINE and and RUBY_VERSION requirements for
the project/package. If given, only matching Rubies can make use of it.

The `engines` field MUST be an array of strings with only a single line of text
in the format of `"<name> [<version-constraint>]"`.

    data = Validator.new

    data.engines = ['mri 1.8.7+', 'jruby']

It can't be anything else.

    no "Foo\nBar"
    no 100
    no :symbol


