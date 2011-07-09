# Spec#authors

The `authors` field holds a list of orginating authors.

The Spec class allows, of course, the canonical format.

    spec = DotRuby::Spec.new

    spec.authors = [
      { 'name'  => 'Bob Williams',
        'email' => 'bob@mail.com'
      },
      { 'name'  => 'John Delight',
        'email' => 'dlite@mail.com'
      }
    ]

But it also can handle and Array of Arrays. The order of the inner array
is `name, email, werbsite`. Only name is not optional.

    spec.authors = [
      ['Bob Williams', 'bob@mail.com'],
      ['John Delight', 'dlite@mail.com', 'http://foo.org']
    ]

It will also handle an Array of strings, parsing out the given parts.

    spec.authors = [
      'Bob Williams <bob@mail.com>',
      'John Delight <dlite@mail.com> http://foo.org'
    ]

It does this via recognition that an email address would be in `<...>`
brackets and URL validation for the website.

It can even handle combination of the above.

    spec.authors = [
      {'name'  => 'Bob Williams', 'email' => 'bob@mail.com'},
      ['Coco Chappel', '<coco@mail.com>'],
      ['John Delight <dlite@mail.com>', 'http://foo.org']
    ]

    spec.authors[0].name.assert  == 'Bob Williams'
    spec.authors[0].email.assert == 'bob@mail.com'

    spec.authors[1].name.assert  == 'Coco Chappel'
    spec.authors[1].email.assert == 'coco@mail.com'

    spec.authors[2].name.assert    == 'John Delight'
    spec.authors[2].email.assert   == 'dlite@mail.com'
    spec.authors[2].website.assert == 'http://foo.org'


