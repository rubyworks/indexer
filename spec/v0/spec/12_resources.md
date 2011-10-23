## Spec#resources

The `resources` field holds a list of URLs index by type.

    spec = Spec.new

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

There are no restrictions on the index value other than it be a one
line string.

    spec.resources = [
      ['whatever',  'http://foo.org'],
      ['something', 'http://foo.org/api'],
    ]

However some _recognized_ resource identifiers are taken to be
synonyms by the underlying Resources class. For example,

    spec.resources = [
      ['home', 'http://foo.org'],
      ['wiki', 'http://foo.org/api'],
      ['chat', '#foo']
    ]

    spec.resources.home.should == spec.resources.homepage
    spec.resources.wiki.should == spec.resources.user_guide
    spec.resources.chat.should == spec.resources.irc

