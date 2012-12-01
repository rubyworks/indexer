## Metadata.find

Given a `.index` file:

    ---
    name: foo
    version: 1.0.0

Then `Metadata.find` will ascend upward in the directory heireachy looking for a
`.index` file.

    file = Indexer::Metadata.find

And we can verify it was found.

    File.basename(file).assert == '.index'

