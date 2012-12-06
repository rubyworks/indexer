## Requirement#optional?

The `optional?` method indicates if a requirement is not necessary.

    r = V0::Requirement.new('foo', :optional => true)

    r.assert.optional?

    r.optional = false

    r.refute.optional?

