# Indexer::V0::Metadata#platforms

The `platform` field holds the RUBY_PLATFORM requirements for the project/package.
If given, only matching platforms can make use of it.

The `platform` field MUST be an array of strings with only a single line of text
that match valid value of RUBY_PLATFORM.

    spec = Indexer::V0::Metadata.new

    spec.platforms = ['x86_64-linux']

TODO: Should we do this?
To ease matching to platforms a '?' and '*' can be used as a wildcard.

    spec.platforms = ['win*']

The field can't be assigned anything else.

    no 100
    no :symbol
    no "Foo\nBar"

Metadata class also support the singular alias.

    spec.platform = ['win*']

Which additionally allows for a single platform assignment.

    spec.platform = 'x86_64-linux'

