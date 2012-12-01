## Indexer::V0::Metadata#resources

The `resources` field holds a list of URLs index by type.

    metadata = Indexer::V0::Metadata.new

    metadata.resources = {
      'home' => 'http://foo.org',
      'docs' => 'http://foo.org/api'
    }

The field can also be assigned an array of two-element arrays.

    metadata.resources = [
      ['home', 'http://foo.org'],
      ['docs', 'http://foo.org/api'],
      ['chat', '#foo']
    ]

But the second element must be a valid URL or a hash tag for IRC chat.

There are no restrictions on the index value other than it be a one
line string.

    metadata.resources = [
      ['whatever',  'http://foo.org'],
      ['something', 'http://foo.org/api'],
    ]

However some _recognized_ resource identifiers are taken to be
synonyms by the underlying Resources class. For example,

    metadata.resources = [
      ['home', 'http://foo.org'],
      ['wiki', 'http://foo.org/api'],
      ['chat', '#foo']
    ]

