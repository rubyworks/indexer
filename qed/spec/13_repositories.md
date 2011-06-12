## Spec#repositories

The `repositories` field holds a list of repository URLs indexed by type.

    spec = DotRuby::Spec.new

    spec.repositories = {
      'public' => 'https://github.com/foostuff/foo.git'
    }

The field can also be assigned an array of two-element arrays.

    spec.repositories = [
      ['public', 'https://github.com/foostuff/foo.git']
    ]


