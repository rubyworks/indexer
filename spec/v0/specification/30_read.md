## Spec.read

Given a `.ruby` file:

    ---
    name: foo
    version: 1.0.0

Then `Spec.read('.ruby')` will read in a file, parse and
validate it and return a new Spec object.

    spec = DotRuby::Spec.read('.ruby')

And we can verify it was read.

    spec.assert.name == 'foo'
    spec.assert.version.to_s == '1.0.0'

