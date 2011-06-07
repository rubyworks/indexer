## Data#licenses

The `licenses` field is a list of license names.

    data = DotRuby::Data.new

    data.licenses = ['GPL3', 'MIT', 'Apache 2.0']

The first license listed MUST be the project's primary license.

The `licenses` field can only be assigned an Array of Strings.

    ok ['GPL3', 'MIT', 'Apache 2.0']
    ok []

    no 'GPL3'
    no 100
    no :symbol

# TODO: what about nil ?

