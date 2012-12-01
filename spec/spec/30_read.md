## Spec.read

Given a `.index` file:

    ---
    name: foo
    version: 1.0.0

Then `Spec.read('.index')` will read in a file, parse and
validate it and return a new Spec object.

    spec = Indexer::Spec.read('.index')

And we can verify it was read.

    spec.assert.name == 'foo'
    spec.assert.version.to_s == '1.0.0'

