# Ruby

Builder can create an index via method_missing.

    builder = Indexer::Builder.new

    builder.name 'example'

    builder.authors 'trans <transfire@gmail.com>',
                    'postmodern'

So then

    spec = builder.spec

    spec.name.assert == 'example'

    spec.authors.size == 2

The Ruby-based builder module uses this fact when loading Ruby-based
sources.

