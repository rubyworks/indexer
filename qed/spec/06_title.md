## Spec#title

The `title` field is used in place of the `name` for documentation
purposes and the like.

    spec = DotRuby::Spec.new

    spec.title = "Tom's Hello World Program"

The `title` value MUST have only one line of text.

    expect DotRuby::InvalidMetadata do
      spec.title = "Foo\nBar"
    end

The Spec class will stip out excess space from a title.

    spec.title = "Foo   Bar"
    spec.title.assert == "Foo Bar"

    spec.title = "Foo  \t  Bar"
    spec.title.assert == "Foo Bar"

If no title is defined, but `name` has been assigned, then the title
will default to the name capitalized.

    spec = DotRuby::Spec.new
    spec.name = "foo"
    spec.title.assert == "Foo"



TODO: Should it have a size limit?

TODO: Should it not allow punctuation marks as the first character?

