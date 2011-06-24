## Spec#repositories

The `repositories` field holds a list of repository URLs indexed by an id.

    spec = DotRuby::Spec.new

    spec.repositories = {
      'public' => {
        'url' => 'https://github.com/foostuff/foo.git',
        'scm' => 'git'
      }
    }

The `scm` field can be omitted. The Repository class will try to infer
it from the URL.

    spec.repositories = {
      'public' => {
        'url' => 'https://github.com/foostuff/foo.git'
      }
    }

   spec.repositories['public'].scm  #=> 'git'

The field can also be assigned a simple hash of ids mapped to URLs.

    spec.repositories = {
      'public' => 'https://github.com/foostuff/foo.git'
    }

The field can also be assigned an associative array.

    spec.repositories = [
      ['public', 'https://github.com/foostuff/foo.git']
    ]

