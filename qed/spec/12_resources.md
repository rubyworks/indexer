## Spec#resources

The `resources` field holds a list of URLs index by type.

    spec = DotRuby::Spec.new

    spec.resources = {
      'home' => 'http://foo.org',
      'docs' => 'http://foo.org/api'
    }

The field can also be assigned an array of two-element arrays.

    spec.resources = [
      ['home', 'http://foo.org'],
      ['docs', 'http://foo.org/api'],
      ['chat', '#foo']
    ]

But the second element must be a valid URL or a hash tag for IRC chat.

