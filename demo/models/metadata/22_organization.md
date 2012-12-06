## Indexer::V0::Metadata#organization

The `organization` field holds the name of the company, club, foundation,
or programming group to which a project belongs. For users of GitHub this
will most likey be the GitHub organization in which a project is hosted.

The `organization` field MUST be a string with only a single line of text.

    ok "dotruby"
    ok "Software Labs, Inc."

    no "Foo\nBar"
    no 100
    no :symbol


