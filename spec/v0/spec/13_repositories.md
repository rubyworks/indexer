## Indexer::V0::Metadata#repositories

The `repositories` field holds a list of repository URLs indexed by an id.

    spec = Indexer::V0::Metadata.new

    spec.repositories = [
      {
        'uri'  => 'https://github.com/foostuff/foo.git',
        'scm'  => 'git',
        'name' => 'main'
      }
    ]

   spec.repositories.first.scm  #=> 'git'

The `scm` field can be omitted, in most cases the Repository class can infer
it from the URI.

    spec.repositories = [
      { 'uri' => 'https://github.com/foostuff/foo.git' }
    ]

   spec.repositories.first.scm  #=> 'git'

The field can also be assigned a simple hash of ids mapped to URIs.

    spec.repositories = {
      'main' => 'https://github.com/foostuff/foo.git'
    }

The field can also be assigned an associative array.

    spec.repositories = [
      ['main', 'https://github.com/foostuff/foo.git']
    ]

Or just simple strings.

    spec.repositories = [
      'https://github.com/foostuff/foo.git'
    ]

Note that is two entries share the same `id`, the first to appear is considered
the primary repository, and the later are considreed fallbacks (such as an SVN
mirror of a GIT repository, for example).

