## Requirement#repository

The `repository` method 

    r = Requirement.new('foo')

    r.repository = {
      :uri => 'http://wootworld.com/foo.git',
      :scm => 'git'
    }

    r.repository.assert.is_a?(Repository)

