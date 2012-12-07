## Validator#version

The `version` field is used to identify the specific version fo the project/package.
Values should follow closely to the SemVer[http://semiver.org] standard.
However, .ruby is somewhat more flexible to accommodate a larger birth of version
numbering policies. As long as the version number (which is actually a string)
starts with a numeric digit and consists of a series of dot and/or dash separated
alphanumeric "point values", then .ruby can work with it.

    data = Indexer::Validator.new

Here are examples of valid version numbers.

    ok "1.0.0"
    ok "1.0a"
    ok "1.0alpha"
    ok "1.0.beta"
    ok "1.0.1.rc.2"
    ok "1.0"

And examples of invalid version numbers.

    no "a.b.c"
    no "1:1:1"
    no "1_1_1"   # TODO: should we accept?
    no "a"
    no :a
    no 1
    no 1.1
    no Object.new

