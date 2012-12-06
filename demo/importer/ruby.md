# Ruby

Importer can create an index via method_missing.

    importer = Indexer::Importer.new

    importer.name 'example'

    importer.authors 'trans <transfire@gmail.com>', 'postmodern'

So then

    metadata = importer.metadata

    metadata.name.assert == 'example'

    metadata.authors.size == 2

The Ruby-based importer module uses this fact when loading Ruby-based
sources.

