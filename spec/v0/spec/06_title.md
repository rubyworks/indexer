## Indexer::V0::Metadata#title

The `title` field is used in place of the `name` for documentation
purposes and the like.

    spec = Indexer::V0::Metadata.new

    spec.title = "Tom's Hello World Program"

The `title` value MUST have only one line of text.

    expect Indexer::ValidationError do
      spec.title = "Foo\nBar"
    end

The Metadata class will stip out excess space from a title.

    spec.title = "Foo   Bar"
    spec.title.assert == "Foo Bar"

    spec.title = "Foo  \t  Bar"
    spec.title.assert == "Foo Bar"

If no title is defined, but `name` has been assigned, then the title
will default to the name capitalized.

    spec = Indexer::V0::Metadata.new
    spec.name = "foo"
    spec.title.assert == "Foo"



TODO: Should it have a size limit?

TODO: Should it not allow punctuation marks as the first character?

