## Validator#resources

The `resources` field holds a list of URLs index by type.

    data = Validator.new

    data.resources = {
      'home' => 'http://foo.org',
      'docs' => 'http://foo.org/api'
    }

The `resource` field MUST be a Hash.

    no 100
    no :symbol
    no "string"
    no Object.new

