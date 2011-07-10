## Validator#repositories

The `repositories` field holds a list of repository URLs indexed by an id.

    data = Validator.new

    data.repositories = {
      'public' => {'url' => 'https://github.com/foostuff/foo.git' }
    }

The field MUST be a Hash.

    no 100
    no :symbol
    no "string"
    no Object.new

