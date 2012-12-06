## Validator#resources

The `resources` field holds a list of URLs index by type.

    data = Indexer::Validator.new

    data.resources = [{
      'home' => 'http://foo.org',
      'docs' => 'http://foo.org/api'
    }]

The `resource` field MUST be a Array.

    no 100
    no :symbol
    no "string"
    no Object.new

