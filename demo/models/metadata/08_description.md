## Indexer::V0::Metadata#description

The `description` field is used to describe a project in detail.
It SHOULD be a single paragraph.

    spec = Indexer::V0::Metadata.new

    spec.description = "HelloWorld is the best way to say hello.\nJust say it!"

While description has no specific size limit, it SHOULD be less than 1,000
characters.

The Metadata class allows any object that responds to #to_s to be assigned to
the `description` field.

    spec.description = :even_a_symbol


