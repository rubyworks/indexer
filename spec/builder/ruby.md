# Ruby

Builder can create an index via method_missing.

    builder = Indexer::Builder.new

    builder.name 'example'

    builder.authors 'trans <transfire@gmail.com>',
                    'postmodern'

So then

    metadata = builder.metadata

    metadata.name.assert == 'example'

    metadata.authors.size == 2

The Ruby-based builder module uses this fact when loading Ruby-based
sources.

