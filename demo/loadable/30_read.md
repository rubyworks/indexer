## Metadata.read

Given a `.index` file:

    ---
    name: foo
    version: 1.0.0

Then `Metadata.read('.index')` will read in a file, parse and
validate it and return a new Metadata object.

    metadata = Indexer::Metadata.read('.index')

And we can verify it was read.

    metadata.assert.name == 'foo'
    metadata.assert.version.to_s == '1.0.0'

