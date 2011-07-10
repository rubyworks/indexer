## Validator#title

The `title` field is used in lue of the `name` for documentation
purposes and the like.

    data = Validator.new

    data.title = "Tom's Hello World Program"

The `title` value MUST have only one lione of text.

    expect DotRuby::ValidationError do
      data.title = "Foo\nBar"
    end

TODO: Should it have a size limit?

TODO: Should it not allow punctuation marks as the first character?

