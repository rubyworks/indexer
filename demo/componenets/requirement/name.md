## Requirement#name

The `name` method

    r = Requirement.parse('foo 1.0+')

    r.name.should == 'foo'

While atypical, we can change the name of ther requirement with `#name=`.

    r.name = 'bar'

    r.name.should == 'bar'

