## Requirement#runtime?

The `#development?` method indicates whether a requirement is for
developing a project, rather than using it.

    r = Requirement.new('foo', :development => true)

    r.assert.development?

Note that if a requirement is used for both runtime and development,
it only need be listed as a runtime requirement.

