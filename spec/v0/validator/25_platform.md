# Validator#platform

The `platforms` field holds the RUBY_PLATFORM requirements for the project/package.
If given, only matching platforms can make use of it.

The `platforms` field MUST be an array of strings with only a single line of text
that match valid value of RUBY_PLATFORM.

    data = Indexer::V0::Validator.new

    data.platforms = ['x86_64-linux']

TODO: Should we do this?
To ease matching to platforms a '?' and '*' can be used as a wildcard.

    data.platforms = ['win*']

The field can't be assigned anything else.

    no "Foo\nBar"
    no 100
    no :symbol

