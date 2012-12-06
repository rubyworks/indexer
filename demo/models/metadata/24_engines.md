# Indexer::V0::Metadata#engines

The `engines` field holds the RUBY_ENGINE and and RUBY_VERSION requirements for
the project/package. If given, only matching Rubies can make use of it.

The `engines` field MUST be an array of strings with only a single line of text
in the format of `"<name> [<version-constraint>]"`.

    spec = Indexer::V0::Metadata.new

    spec.engines = ['mri 1.8.7+', 'jruby']

It can't be anything else.

    no "Foo\nBar"
    no 100
    no :symbol

Metadata class also support the singular alias.

    spec.engine = ['mri 1.8.7+', 'jruby']

Which additionally allows for a single platform assignment.

    spec.engine = 'mri 1.8.7+'

