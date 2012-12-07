## Requirement#runtime?

The `runtime?` method is the inverse of the `#development?` method.

    r = Requirement.new('foo', :development => true)

    r.refute.runtime?

