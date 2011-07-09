## Spec#suite

The `suite` field is used to identify the _suite_ of packages that a package
belongs. For example Microsoft "Word" is part of the Microsoft "Office" suite.

The `suite` field MUST be a string with only a single line of text.

    ok "Office"
    ok "RDoc"

    no 100
    no :symbol
    no "Foo\nBar"

