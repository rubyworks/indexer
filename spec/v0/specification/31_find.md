## Spec.find

Given a `.ruby` file:

    ---
    name: foo
    version: 1.0.0

Then `Spec.find` will ascend upward in the directory heireachy looking for a
`.ruby` file. If found it will read, parse and validate it and then return
a new Spec object.

    spec = DotRuby::Spec.find

And we can verify it was read.

    spec.assert.name == 'foo'
    spec.assert.version.to_s == '1.0.0'

